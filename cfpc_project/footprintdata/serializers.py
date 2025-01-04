from rest_framework import serializers
from footprintdata import models as footprintdata_models
from login import models as login_models

from django.db import models

data = footprintdata_models.data

# Serializers for inserting data

class ActivityTypeSerializer(serializers.Serializer):
    
    activity = serializers.IntegerField()

    def validate(self, data1):

        activity = data1['activity']

        if activity not in [int(i) for i in data['Activities'].values()]:
            raise serializers.ValidationError("Invalid activity selected!")
        
        return activity

    def to_representation(self, instance):
        
        activity = self.validated_data.get('activity')
        
        types = list(data['Types'].get(str(activity), {}).items())
        
        return {'types': types}
    
class TypeParameterSerializer(serializers.Serializer):

    activity = serializers.IntegerField()
    type_ = serializers.IntegerField()

    def validate(self, data1):

        activity = data1['activity']
        type_ = data1['type_']
        
        if activity not in [int(i) for i in data['Activities'].values()]:
            raise serializers.ValidationError("Invalid activity selected!")
        
        if type_ not in [int(i) for i in data['Types'].values()]:
            raise serializers.ValidationError("Invalid type selected!")
        
        return activity, type_
    
    def to_representation(self, instance):
        
        activity = self.validated_data.get('activity')
        type_ = self.validated_data.get('type_')
        
        parameter = data['parameters'].get(str(activity), {}).get(str(type_), None)
        
        return {'parameter': parameter}

class FootprintsSerializer(serializers.ModelSerializer):
    
    class Meta:

        model = footprintdata_models.Footprints
        fields = ['user', 'activity', 'type_', 'parameter']

    def validate(self, data1):

        activity = data1['activity']
        type_ = data1['type_']
        parameter = data1['parameter']

        if str(activity) not in data['EmissionFactors']:
            raise serializers.ValidationError("Invalid emission factor for the selected activity.")
        
        if str(type_) not in data['EmissionFactors'][str(activity)]:
            raise serializers.ValidationError("Invalid emission factor for the selected type.")
        
        # make the parameter ranges in the json file, and check if the parameter is within the range to validate.
        if parameter <= 0:
            raise serializers.ValidationError("Parameter must be a positive number.")
        
        return data1
        

    def create(self, validated_data):
        
        footprint = footprintdata_models.Footprints(**validated_data)
        
        footprint.save()
        
        return footprint

# Serialisers for viewing data

class FootprintsViewSerializer(serializers.ModelSerializer):
    
    user = serializers.PrimaryKeyRelatedField(queryset = login_models.CustomUser.objects.all())
    time_start = serializers.DateTimeField()
    time_end = serializers.DateTimeField()
    activity = serializers.IntegerField()

    def validate(self, data1):
        if data1['time_start'] >= data1['time_end']:
            raise serializers.ValidationError("Invalid time range!")
        if data1['activity'] not in [int(i) for i in data['Activities'].values()]:
            raise serializers.ValidationError("Invalid activity!")
        return data1
    
    def get_data(self, validated_data):
        user = validated_data['user']
        activity = validated_data['activity']
        time_start = validated_data['time_start']
        time_end = validated_data['time_end']

        try:
            footprints = footprintdata_models.Footprints.objects.select_related('user').filter(
                user = user,
                activity = activity,
                time_of_entry__range = (time_start, time_end)
            )


            return {
                "entries": list(footprints.values('time_of_entry', 'activity', 'type_', 'parameter', 'carbon_footprint', 'number_of_trees'))
                # manipulation of data will be done by frontend (statistics and graphs)
            }
    
        except Exception as e:
            raise serializers.ValidationError(f"Error: {str(e)}")

    def to_representation(self, instance):

        return self.get_data(self.validated_data)