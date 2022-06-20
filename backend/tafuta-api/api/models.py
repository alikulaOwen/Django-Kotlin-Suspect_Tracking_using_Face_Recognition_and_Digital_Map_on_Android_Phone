from email.policy import default
from django.db import models
from django.utils import timezone
from django.core.validators import MaxValueValidator, MinValueValidator
from rest_framework.decorators import action
import face_recognition
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from account.models import Officer
import numpy as np
import datetime


def name_file(instance, filename):
    name = str(instance.name).replace('_', '')
    file_nm = str(filename[-3:])
    if file_nm == 'peg':
        file_nm = 'jpg'
    return '/'.join([name + '.' + file_nm])


MALE = "MALE"
FEMALE = "FEMALE"
OTHER = "OTHER"
UNKNOWN = "UNKNOWN"

SEX_CHOICES = (
    (MALE, "MALE"),
    (FEMALE, "FEMALE"),
    (OTHER, "OTHER"),
    (UNKNOWN, "UNKNOWN")
)


class Suspect(models.Model):
    name = models.CharField(max_length=200, null=False)
    mugshot = models.ImageField(upload_to=name_file, blank=False)
    face_encoding = models.TextField(max_length=900, null=False, editable=False)
    charges = models.CharField(max_length=5000, null=False)
    sex = models.CharField(max_length=7, null=False, choices=SEX_CHOICES)
    national_id = models.IntegerField(default=0, unique=True, validators=[MaxValueValidator(99999999)])
    phone_number = models.IntegerField(unique=True)
    is_seen = models.BooleanField(default=False)
    physical_attributes = models.CharField(max_length=500, null=False)
    birth_date = models.DateField()
    date_posted = models.DateTimeField(auto_now_add=True, null=False, blank=False)
    date_modified = models.DateTimeField(auto_now=True, null=False, blank=False)
    filed_by = models.ForeignKey(Officer, on_delete=models.CASCADE) 
 
    def __repr__(self):
        return self.name

    def __str__(self):
        return self.name + ' - National Id: ' + str(self.national_id)
        # return f"Suspect('{self.name}')"
    
    def save(self, *args, **kwargs):
        image = face_recognition.load_image_file(self.mugshot)
        face_count = len(face_recognition.face_locations(image))
        
        if face_count != 1:
            raise ValidationError(
                _('%(value)s Image has no face or has more than one face'),
                params={'value': face_count},)
        else:
            k = np.ndarray.tolist(face_recognition.face_encodings(image)[0])
            self.face_encoding = k
            super(Suspect, self).save(*args, **kwargs)


class Location(models.Model):
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=False)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=False)
    county = models.CharField(max_length=200, null=False, default='null')
    sub_county = models.CharField(max_length=200, null=False, default='null')
    constituency = models.CharField(max_length=200, null=False, default='null')
    suspect_seen = models.ForeignKey(Suspect, on_delete=models.CASCADE)

    def __str__(self):
        return 'Lat: ' + str(self.latitude) + ' Long: ' + str(self.longitude) + " -> " + str(self.suspect_seen)
    
    # def current_epg(self):
    #     return Suspect.objects.filter(location=self)
