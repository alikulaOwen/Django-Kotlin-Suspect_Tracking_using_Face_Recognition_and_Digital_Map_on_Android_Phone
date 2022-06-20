import ast
import json
import os
import django
import numpy as np

import cv2
from PIL import Image, ImageDraw
import face_recognition as fr
from django.conf import settings
import time
import datetime
import pandas as pd


def hello():
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "tafuta.settings")
    django.setup()

    from api.models import Suspect, Location

    cap = cv2.VideoCapture('http://192.168.81.209:8080/video')

    face_cascade = cv2.CascadeClassifier(os.path.join(settings.BASE_DIR, 'livestream/opencv_haarcascade_data/haarcascade_frontalface_default.xml'))
    body_cascade = cv2.CascadeClassifier(os.path.join(settings.BASE_DIR, 'livestream/opencv_haarcascade_data/haarcascade_fullbody.xml'))

    detection = False
    detection_stopped_time = None
    timer_started = False
    SECONDS_TO_RECORD_AFTER_DETECTION = 5

    frame_size = (int(cap.get(3)), int(cap.get(4)))
    fourcc = cv2.VideoWriter_fourcc(*"mp4v")

    faces = Suspect.objects.values_list('face_encoding')
    face = json.dumps(list(faces))
    j = ast.literal_eval(face)
    known_face_encodings = []

    for face in j:
        new = str(face)[2:][:-2]
        lis = ast.literal_eval(new)

        numpy_array = np.asarray(lis)
        known_face_encodings.append(numpy_array)

    suspect = Suspect.objects.filter(face_encoding__in=faces).all()
    known_face_names = pd.DataFrame(suspect).values.tolist()

    count = 0

    while True:
        _, frame = cap.read()

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        gray_pil = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)  # for pillow to draw colored images
        faces = face_cascade.detectMultiScale(gray, 1.3, 5)
        bodies = body_cascade.detectMultiScale(gray, 1.3, 5)

        if len(faces) + len(bodies) > 0:
            if detection:
                timer_started = False
            else:
                detection = True
                current_time = datetime.datetime.now().strftime("%d-%m-%Y-%H-%M-%S")
                out = cv2.VideoWriter(
                    f"/home/don/myprojects/tafutaApi-master/static/foundVideos/{current_time}.mp4", fourcc, 20, frame_size)
                print("Started Recording!")
        elif detection:
            if timer_started:
                if time.time() - detection_stopped_time >= SECONDS_TO_RECORD_AFTER_DETECTION:
                    detection = False
                    timer_started = False
                    out.release()
                    print('Stop Recording!')
            else:
                timer_started = True
                detection_stopped_time = time.time()

        if detection:
            out.write(frame)

        for (x, y, w, h) in faces:
            # print(x,y,w,h)
            roi_gray = gray[y:y + h, x:x + w]
            roi_color = gray[y:y + h, x:x + w]

            # recognize -
            face_locations = fr.face_locations(frame)  # add model
            face_encodings = fr.face_encodings(frame, face_locations)

            for (top, right, bottom, left), face_encoding in zip(face_locations, face_encodings):
                matches = fr.compare_faces(known_face_encodings, face_encoding, tolerance=0.42)

                name = "Unknown Person"

                face_distances = fr.face_distance(known_face_encodings, face_encoding)

                best_match_index = np.argmin(face_distances)
                if matches[best_match_index]:
                    name = known_face_names[best_match_index]
                    print(f"Found {name}")

                    name_lookup = str(name).strip('[').strip(']')

                    try:
                        sus = Suspect.objects.get(name=name_lookup).id
                        suspect_id = Suspect.objects.get(name=name_lookup).id
                        sus = Suspect.objects.get(id=sus)

                        sus.is_seen = 1
                        loca = Location(latitude=1.292100, longitude=36.821900, county='Narok', sub_county='Narok',
                                        suspect_seen_id=suspect_id)
                        sus.save()
                        loca.save()
                    except Exception as e:
                        print(e)

                    pil_image = Image.fromarray(gray_pil)
                    draw = ImageDraw.Draw(pil_image)
                    # Draw Box
                    draw.rectangle(((left, top), (right, bottom)), outline='yellow', width=2)
                    # Draw label
                    text_width, text_height = draw.textsize(name)
                    draw.rectangle(((left, bottom - text_height - 10), (right, bottom)), fill=(255, 255, 0),
                                   outline=(255, 255, 0))
                    draw.text((left + 6, bottom - text_height - 5), str(name), fill=(0, 0, 0))
                    del draw
                    # Display imagetime
                    if name == "Unknown Person":
                        pil_image.save(f'/home/don/myprojects/tafutaApi-master/static/found/{name + str(count)}.jpg')
                        count += 1
                    else:
                        pil_image.save(f'/home/don/myprojects/tafutaApi-master/static/found/{name}.jpg')

        # cv2.imshow("Camera", frame)
        #
        # if cv2.waitKey(1) == ord('q'):
        #     break

    # out.release()
    # cap.release()
    # cv2.destroyAllWindows()


def run():
    hello()

