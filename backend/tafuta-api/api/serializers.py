from .models import Suspect, Location
from account.models import Officer
from rest_framework import serializers
from rest_framework.response import Response


class OfficerSerializer(serializers.HyperlinkedModelSerializer):
    password2 = serializers.CharField(style={'input_type': 'password'}, write_only=True)

    class Meta:
        model = Officer
        # exclude = ('password',)
        fields = "__all__"
        extra_Kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        user = Officer(
            email=self.validated_data['email'],
            national_id=self.validated_data['national_id'],
            employee_id=self.validated_data['employee_id'],
            username=self.validated_data['username'],
            phone_number=self.validated_data['phone_number'],
            department=self.validated_data['department'],
            is_admin=self.validated_data['is_admin'],
            is_active=self.validated_data['is_active'],
            is_staff=self.validated_data['is_staff'],
            is_superuser=self.validated_data['is_superuser']
        )
        password = self.validated_data['password']
        password2 = self.validated_data['password2']

        if password != password2:
            raise serializers.ValidationError({'password': 'Passwords must match.'})

        user.set_password(self.validated_data['password'])
        user.save()
        return user


class SuspectSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        depth = 1
        model = Suspect
        fields = "__all__"


class LocationSerializer(serializers.HyperlinkedModelSerializer):
    # suspect = SuspectSerializer(many=True, read_only=True, source="current_epg")
    
    # results_field = 'locations'
    class Meta:
        depth = 1
        model = Location
        fields = "__all__"
    
    
