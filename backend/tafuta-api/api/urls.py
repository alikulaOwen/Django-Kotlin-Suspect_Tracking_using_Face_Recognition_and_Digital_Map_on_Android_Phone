from django.urls import re_path, path, include
from rest_framework import routers
from api import views
from rest_framework_swagger.views import get_swagger_view
from api.views import CustomAuthToken
from rest_framework.authtoken.views import obtain_auth_token

router = routers.DefaultRouter()
router.register('suspects', viewset=views.SuspectViewSet)
router.register('officers', viewset=views.OfficerViewSet)
router.register('locations', viewset=views.LocationViewSet)
schema_view = get_swagger_view(title='Pastebin API')

# The API URLs are now determined automatically by the router.
# Additionally, we include the login URLs for the browsable API.
urlpatterns = [
    path('', include(router.urls)),
    path('schema/', schema_view, name='schema'),
    path('register-officer/', CustomAuthToken.as_view(), name='register'),
    path('login/', obtain_auth_token, name='login')
]
