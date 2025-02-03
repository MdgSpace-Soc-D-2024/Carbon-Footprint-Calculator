from rest_framework import serializers
from login import models

import re

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length = 50)
    password = serializers.CharField(write_only = True, style = {'input_type': 'password'})

    def validate(self, data):

        username = data.get('username')
        password = data.get('password')
        
        if not username or not password:
            raise serializers.ValidationError("Username or Password can not be empty!")
        
        if not models.CustomUser.objects.filter(username = data.get('username')).exists():
            raise serializers.ValidationError("User does not exist!")

        # other validation rules for username and password
        
        return data

    def to_representation(self, instance):
        return {}

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only = True, style = {'input_type': 'password'})
    age = serializers.IntegerField(required = False)
    profession = serializers.IntegerField(required = False)
    purpose_of_joining = serializers.IntegerField(required = False)

    class Meta:
        model = models.CustomUser
        fields = ['username', 'password', 'name', 'age', 'profession', 'purpose_of_joining']

    def validate(self, data):

        def validate_password(password):
            if len(password) < 8:
                raise serializers.ValidationError('Password must be at least 8 characters long')
            if not re.search(r'[A-Z]', password):
                raise serializers.ValidationError('Password must contain at least one uppercase letter')
            if not re.search(r'[a-z]', password):
                raise serializers.ValidationError('Password must contain at least one lowercase letter')
            if not re.search(r'\d', password):
                raise serializers.ValidationError('Password must contain at least one digit')
            if not re.search(r'[@$!%*?&]', password):
                raise serializers.ValidationError('Password must contain at least one special character')

        username = data.get('username')
        password = data.get('password')
        age = data.get('age')

        if not username or not password:
            raise serializers.ValidationError("Username or Password can not be empty!")
        
        if models.CustomUser.objects.filter(username = username).exists():
            raise serializers.ValidationError("Username already exists!")
        
        validate_password(password)

        if age and age < 0:
            raise serializers.ValidationError("Age can not be negative!")
        
        # any other validation may be put here!
        
        return data
    
    def create(self, validated_data):
        
        user = models.CustomUser.objects.create(
            username = validated_data.get('username'),
            name = validated_data.get('name'),
            age = validated_data.get('age'),
            profession = validated_data.get('profession'),
            purpose_of_joining = validated_data.get('purpose_of_joining'),
        )
        
        user.set_password(validated_data.get('password'))
        user.save()
        
        return user
    
    def to_representation(self, instance):
        return {
            "username": self.validated_data.get('username'),
            "name": self.validated_data.get('name'),
            "age": self.validated_data.get('age'),
            "porofession": self.validated_data.get('profession'),
            "purpose_of_joining": self.validated_data.get('purpose_of_joining')
        }


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.CustomUser
        fields = ['username', 'name', 'age', 'profession', 'purpose_of_joining', 'date_joined', 'carbon_footprint', 'is_superuser', 'is_admin', 'is_active', 'is_staff']
        read_only_fields = ['id', 'date_joined', 'carbon_footprint', 'is_active', 'is_staff']