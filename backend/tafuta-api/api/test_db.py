from django.apps import apps

model = apps.get_model('api', 'Suspect')

r = model.objects.values_list('id', 'face_encoding')

print(r)
