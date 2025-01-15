from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from login import models

# admin.site.register(models.CustomUser)

class CustomUserAdmin(UserAdmin):
    model = models.CustomUser
    list_display = ('username', 'name', 'is_staff', 'is_superuser', 'is_active')
    list_filter = ('is_staff', 'is_superuser', 'is_active')
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Personal Info', {'fields': ('name', 'age', 'profession', 'purpose_of_joining')}),
        ('Permissions', {'fields': ('is_staff', 'is_superuser', 'is_active')}),
        ('Important Dates', {'fields': ('date_joined',)}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2', 'is_staff', 'is_superuser', 'is_active'),
        }),
    )
    search_fields = ('username',)
    ordering = ('username',)
    filter_horizontal = tuple()

admin.site.register(models.CustomUser, CustomUserAdmin)