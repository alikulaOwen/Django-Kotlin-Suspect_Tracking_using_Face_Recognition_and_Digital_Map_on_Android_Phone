from django.shortcuts import render
from django.http.response import StreamingHttpResponse
from livestream.camera import IPWebCam
import numpy as np
import json
import ast
from api.models import Suspect
# Create your views here.


def index(request):
    return render(request, 'streamapp/home.html')


def encodings(request):
    faces = Suspect.objects.values_list('face_encoding')
    face = json.dumps(list(faces))
    j = ast.literal_eval(face)

    for face in j:
        new = str(face)[2:][:-2]
        lis = ast.literal_eval(new)

        numpy_array = np.asarray(lis)
        suspect = Suspect.objects.filter(face_encoding__in=faces).all()

        print(numpy_array)
        print(suspect)

    return render(request, 'streamapp/encodings.html', {'face': numpy_array})


def gen(camera):
    while True:
        frame = camera.get_frame()
        yield (b'--frame\r\n'
                b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n\r\n')


def webcam_feed(request):
    return StreamingHttpResponse(gen(IPWebCam()),
                    content_type='multipart/x-mixed-replace; boundary=frame')