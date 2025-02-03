from rest_framework import serializers
from footprintdata import models as footprintdata_models
from login import models as login_models

from django.db import models

from django.utils import timezone

from django.utils.dateparse import parse_datetime

data = footprintdata_models.data

# Serializers for inserting data

class ActivityTypeSerializer(serializers.Serializer):
    
    activity = serializers.IntegerField()

    def validate(self, data1):

        activity = data1['activity']

        permissible_activities = list(int(i) for i in list(data.get('Activities').values()))

        if activity not in permissible_activities:
            raise serializers.ValidationError("Invalid activity selected!")
        
        return activity

    def to_representation(self, instance):
        
        activity = self.validated_data.get('activity')
        
        types = list(data.get('Types').get(str(activity), {}).items())
        
        return {'types': types}
    
class TypeParameterSerializer(serializers.Serializer):

    activity = serializers.IntegerField()
    type_of_activity = serializers.IntegerField()

    def validate(self, data1):

        activity = data1['activity']
        type_of_activity = data1['type_of_activity']

        permissible_activities = list(int(i) for i in list(data.get('Activities').values()))
        
        if activity not in permissible_activities:
            raise serializers.ValidationError("Invalid activity selected!")
        
        else:

            permissible_types = list(int(i) for i in list(data.get('Types').get(str(activity)).values()))
        
            if type_of_activity not in permissible_types:
                raise serializers.ValidationError("Invalid type selected!")
        
        return activity, type_of_activity
    
    def to_representation(self, instance):
        
        activity = self.validated_data.get('activity')
        type_of_activity = self.validated_data.get('type_of_activity')
        
        parameter = data['parameters'].get(str(activity), {}).get(str(type_of_activity), None)
        
        return {'parameter': parameter}

class FootprintsSerializer(serializers.Serializer):
    
    # class Meta:

    #     model = footprintdata_models.Footprints
    #     fields = ['activity', 'type_of_activity', 'parameter']

    activity = serializers.IntegerField()
    type_of_activity = serializers.IntegerField()
    parameter = serializers.FloatField()

    def validate(self, data1):

        activity = data1['activity']
        type_of_activity = data1['type_of_activity']
        parameter = data1['parameter']

        if str(activity) not in data['EmissionFactors']:
            raise serializers.ValidationError("Invalid emission factor for the selected activity.")
        
        if str(type_of_activity) not in data['EmissionFactors'][str(activity)]:
            raise serializers.ValidationError("Invalid emission factor for the selected type.")
        
        # make the parameter ranges in the json file, and check if the parameter is within the range to validate.
        if parameter <= 0:
            raise serializers.ValidationError("Parameter must be a positive number.")
        
        return data1
        

    def create(self, validated_data):

        try:
            
            validated_data['user'] = self.context['request'].user
        
        except Exception as e:
            
            serializers.ValidationError(f"Error: {e}")
        
        validated_data['activity'] = int(validated_data.get('activity'))
        validated_data['type_of_activity'] = int(validated_data.get('type_of_activity'))
        validated_data['parameter'] = float(validated_data.get('parameter'))
        
        footprint = footprintdata_models.Footprints(**validated_data)

        footprint.save()
        
        return footprint
    
    def to_representation(self, instance):
        return super().to_representation(instance)

# Serialisers for viewing data

class FootprintsViewSerializer(serializers.Serializer):
    
    time_start = serializers.DateTimeField()
    time_end = serializers.DateTimeField()
    activity = serializers.IntegerField()

    def validate(self, data1):

        time_start = (data1.get('time_start'))
        time_end = (data1.get('time_end'))
        activity = int(data1.get('activity'))

        if time_start >= time_end:
            raise serializers.ValidationError("Invalid time range!")
        
        if str(activity) not in data['Activities'].values():
            raise serializers.ValidationError("Invalid activity!")
        
        footprints = footprintdata_models.Footprints.objects.select_related('user').filter(
                user = self.context['request'].user,
                activity = activity,
                time_of_entry__range = (time_start, time_end))
        
        if not footprints.exists():
            raise serializers.ValidationError("No activity found within the given time frame.")
        
        return data1

    def to_representation(self, instance):

        return {}