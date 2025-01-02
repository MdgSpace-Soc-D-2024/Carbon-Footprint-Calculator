from rest_framework import serializers
from login import models

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length = 50)
    password = serializers.CharField(write_only = True, style = {'input_type': 'password'})

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only = True, style = {'input_type': 'password'})

    class Meta:
        model = models.CustomUser
        fields = ['username', 'password', 'name', 'age', 'profession', 'purpose_of_joining']
    
    def create(self, validated_data):
        user = models.CustomUser.objects.create(
            username = validated_data['username'],
            name = validated_data.get('name'),
            age = validated_data.get('age'),
            profession = validated_data.get('profession'),
            purpose_of_joining = validated_data.get('purpose_of_joining'),
        )
        
        user.set_password(validated_data['password'])
        user.save()
        
        return user


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.CustomUser
        fields = ['username', 'name', 'age', 'profession', 'purpose_of_joining', 'date_joined', 'carbon_footprint', 'is_superuser', 'is_admin', 'is_active', 'is_staff']
        read_only_fields = ['id', 'date_joined', 'carbon_footprint', 'is_active', 'is_staff']