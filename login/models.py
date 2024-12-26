from django.db import models
from django.utils import timezone
from django.conf import settings
from django.contrib.auth.hashers import make_password

# from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

professions = [(1, 'Student'), (2, 'Educator (Teacher/Professor)'), (3, 'Engineer/Technician'), (4, 'Healthcare Professional'), (5, 'Corporate/Office Worker'), (6, 'Service Industry (Retail/Hospitality)'), (7, 'Agriculture/Fisheries'), (8, 'Self-Employed'), (9, 'Other')]
purpose = [(1, 'Personal'), (2, 'Research/Academic Purposes'), (3, 'Business/Commercial'), (4, 'Other')]

class User(models.Model):
    username = models.CharField(max_length = 50, unique = True)
    password = models.CharField(max_length = 200)
    name = models.CharField(max_length = 100, default = 'Anonymous')
    age = models.IntegerField(null = True)
    date_joined = models.DateTimeField(default = timezone.now)
    profession = models.IntegerField(choices = professions, default = 9, null = True)
    purpose_of_joining = models.IntegerField(choices = purpose, default = 4, null = True)
    carbon_footprint = models.FloatField(default = 0.0)
    is_superuser = models.BooleanField(default = False)
    is_active = models.BooleanField(default = True)

    REQUIRED_FIELDS = ['password']
    USERNAME_FIELD = 'username'

    def __str__(self):
        return self.username
    
    @property
    def is_authenticated(self):
        # Return True if the user is not anonymous
        return self.is_active

    @property
    def is_anonymous(self):
        # Return True if the user is anonymous (not authenticated)
        return not self.is_active

    # You can implement methods like check_password manually if necessary
    def check_password(self, raw_password):
        return self.password == make_password(raw_password)

    def set_password(self, raw_password):
        self.password = make_password(raw_password)