from django.shortcuts import render
from .models import Suspect, Officer, Location
from rest_framework import viewsets, filters
from .serializers import SuspectSerializer, OfficerSerializer, LocationSerializer
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.views import ObtainAuthToken


class SuspectViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = SuspectSerializer
    queryset = Suspect.objects.all()
    filter_backends = [filters.SearchFilter]
    search_fields = ['=id', 'name', 'national_id']


class OfficerViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Officer.objects.all()
    serializer_class = OfficerSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['=id', 'username', 'phone_number', 'national_id']


class LocationViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    queryset = Location.objects.all()
    serializer_class = LocationSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['=id', 'county', 'sub_county', 'constituency', 'suspect_seen__name', ]

    def list(self, request, *args, **kwargs):
        self.object_list = self.filter_queryset(self.get_queryset())
        serializer = self.get_serializer(self.object_list, many=True)
        return Response({'locations': serializer.data})


class CustomAuthToken(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        serializer = OfficerSerializer(data=request.data)
        data = {}
        if serializer.is_valid():
            officer = serializer.save()
            data['response'] = 'successfully registered new user. Check with Admin to activate you.'
            data['email'] = officer.email
            data['username'] = officer.username
            data['national_id'] = officer.national_id
            data['employee_id'] = officer.employee_id
            data['phone_number'] = officer.phone_number
            data['department'] = officer.department
            token = Token.objects.get(user=officer).key
            data['token'] = token
        else:
            data = serializer.errors
        return Response(data)


def custom_page_not_found_view(request, exception):
    return render(request, "errors/404.html", {})


def custom_error_view(request, exception=None):
    return render(request, "errors/500.html", {'message': 'message'})


def custom_permission_denied_view(request, exception=None):
    return render(request, "errors/403.html", {})


def custom_bad_request_view(request, exception=None):
    return render(request, "errors/400.html", {})


all_entries = Suspect.objects.all()