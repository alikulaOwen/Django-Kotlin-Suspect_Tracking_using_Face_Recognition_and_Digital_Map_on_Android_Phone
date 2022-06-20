import cv2
import os
import urllib.request
import numpy as np
from django.conf import settings

face_detection_cascade = cv2.CascadeClassifier(os.path.join(
    settings.BASE_DIR, 'livestream/opencv_haarcascade_data/haarcascade_frontalface_default.xml'))
body_detection_cascade = cv2.CascadeClassifier(os.path.join(
    settings.BASE_DIR, 'livestream/opencv_haarcascade_data/haarcascade_fullbody.xml'))


class IPWebCam(object):
    def __init__(self):
        self.url = "http://192.168.81.209:8080/shot.jpg"

    def __del__(self):
        cv2.destroyAllWindows()

    def get_frame(self):
        detection = False
        timer_started = False
        detection_stopped_time = None
        imgResp = urllib.request.urlopen(self.url)
        imgNp = np.array(bytearray(imgResp.read()), dtype=np.uint8)
        img = cv2.imdecode(imgNp, -1)
        # We are using Motion JPEG, but OpenCV defaults to capture raw images,
        # so we must encode it into JPEG in order to correctly display the
        # video stream
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        faces_detected = face_detection_cascade.detectMultiScale(gray, scaleFactor=1.3, minNeighbors=5)

        for (x, y, w, h) in faces_detected:
            cv2.rectangle(img, pt1=(x, y), pt2=(x + w, y + h), color=(255, 0, 0), thickness=2)
        resize = cv2.resize(img, (640, 480), interpolation=cv2.INTER_LINEAR)
        frame_flip = cv2.flip(resize, 1)
        ret, jpeg = cv2.imencode('.jpg', frame_flip)

        cv2.destroyAllWindows()

        return jpeg.tobytes()


