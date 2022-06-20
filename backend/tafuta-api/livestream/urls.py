from django.urls import path, include
from livestream import views


urlpatterns = [
    path('', views.index, name='index'),
    path('face/', views.encodings, name='encodings'),
    path('webcam_feed', views.webcam_feed, name='webcam_feed'),
]
