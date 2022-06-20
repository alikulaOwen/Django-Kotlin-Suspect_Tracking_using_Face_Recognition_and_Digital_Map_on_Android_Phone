from django import forms
from django.contrib import admin
from .models import Officer
from django.contrib.auth.admin import UserAdmin


class UserCreationForm(forms.ModelForm):
    password1 = forms.CharField(label='Password', widget=forms.PasswordInput)
    password2 = forms.CharField(label='Password confirmation', widget=forms.PasswordInput)

    class Meta:
        model = Officer
        fields = '__all__'

    def clean_password2(self):
        password1 = self.cleaned_data.get("password1")
        password2 = self.cleaned_data.get("password2")
        if password1 and password2 and password1 != password2:
            raise forms.ValidationError("Passwords don't match")
        return password2

    def save(self, commit=True):
        user = super().save(commit=False)
        user.set_password(self.cleaned_data["password1"])
        if commit:
            user.save()
        return user


class AccountAdmin(UserAdmin):
    add_form = UserCreationForm
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('email', 'national_id', 'username', 'phone_number', 'employee_id', 'department', 'is_admin',
                       'password1', 'password2', 'is_active', 'is_staff', 'is_superuser')}
         ),
    )
    list_display = ('email', 'national_id', 'username', 'phone_number', 'is_admin', 'is_active')
    search_fields = ('email', 'national_id', 'username', 'phone_number')
    readonly_fields = ('date_joined', 'last_login')
    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()


admin.site.register([Officer], AccountAdmin)
