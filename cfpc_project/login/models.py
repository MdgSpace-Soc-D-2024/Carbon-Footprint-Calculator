from django.db import models
from django.utils import timezone
# from django.conf import settings
# from django.contrib.auth.hashers import make_password

from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class CustomUserManager(BaseUserManager):
    def create_user(self, username, password, **extra_fields):
        if not username or not password:
            raise ValueError('Username and password are required')
        else:
            user = self.model(username = username, **extra_fields)
            user.set_password(password)
            user.save(using = self._db)
            return user

    def create_superuser(self, username, password, **extra_fields):
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('is_staff', True)
    
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser = True.')
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff = True.')

        return self.create_user(username, password, **extra_fields)

professions = [(1, 'Student'), (2, 'Educator (Teacher/Professor)'), (3, 'Engineer/Technician'), (4, 'Healthcare Professional'), (5, 'Corporate/Office Worker'), (6, 'Service Industry (Retail/Hospitality)'), (7, 'Agriculture/Fisheries'), (8, 'Self-Employed'), (9, 'Other')]
purpose = [(1, 'Personal'), (2, 'Research/Academic Purposes'), (3, 'Business/Commercial'), (4, 'Other')]

class CustomUser(AbstractBaseUser, PermissionsMixin):
    username = models.CharField(max_length = 50, unique = True, primary_key = True)
    # password = models.CharField(max_length = 200)
    # already in AbstractBaseUser class
    
    name = models.CharField(max_length = 100, default = 'Anonymous')
    age = models.IntegerField(null = True)
    
    profession = models.IntegerField(choices = professions, default = 9)
    purpose_of_joining = models.IntegerField(choices = purpose, default = 4)

    date_joined = models.DateTimeField(default = timezone.now)
    
    carbon_footprint = models.FloatField(default = 0.0)
    
    is_superuser = models.BooleanField(default = False)
    is_active = models.BooleanField(default = True)
    is_admin = models.BooleanField(default = False)
    is_staff = models.BooleanField(default = False)

    REQUIRED_FIELDS = []
    USERNAME_FIELD = 'username'

    objects = CustomUserManager()

    def __str__(self):
        return self.username
    
    # @property
    # def is_authenticated(self):
    #     # Return True if the user is not anonymous
    #     return self.is_active

    # def check_password(self, raw_password):
    #     return super().check_password(raw_password)

    # def set_password(self, raw_password):
    #     self.password = make_password(raw_password)
    
    # already in the AbstractBaseUser class