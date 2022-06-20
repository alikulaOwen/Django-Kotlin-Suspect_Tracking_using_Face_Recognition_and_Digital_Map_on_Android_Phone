"""
WSGI config for tafuta project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.0/howto/deployment/wsgi/
"""

import os
import sys
from django.core.wsgi import get_wsgi_application
# from whitenoise.django import DjangoWhiteNoise
sys.path.append('/home/don/tafutaApi')
sys.path.append('/home/don/tafutaApi/tafuta')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'tafuta.settings')

application = get_wsgi_application()
# application = DjangoWhiteNoise(application)
