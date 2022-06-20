from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from api.models import Suspect, Location


class SuspectAdmin(admin.ModelAdmin):
    list_display = ('name', 'national_id', 'phone_number', 'is_seen', 'filed_by', 'mugshot')
    search_fields = ('name', 'national_id', 'phone_number')
    readonly_fields = ('date_posted', 'date_modified')
    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()


class LocationAdmin(admin.ModelAdmin):
    list_display = ('suspect_seen', 'latitude', 'longitude', 'county', 'sub_county', 'constituency')
    search_fields = ('suspect_seen', 'latitude', 'longitude', 'county', 'sub_county', 'constituency')
    # readonly_fields = ('latitude', 'longitude')
    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()


admin.site.register([Suspect], SuspectAdmin)
admin.site.register([Location], LocationAdmin)
