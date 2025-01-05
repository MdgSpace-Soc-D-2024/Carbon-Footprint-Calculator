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

class FootprintsSerializer(serializers.ModelSerializer):
    
    class Meta:

        model = footprintdata_models.Footprints
        fields = ['user', 'activity', 'type_of_activity', 'parameter']

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

        validated_data['user'] = self.context['request'].user

        validated_data['activity'] = int(validated_data['activity'])
        validated_data['type_of_activity'] = int(validated_data['type_of_activity'])
        validated_data['parameter'] = float(validated_data['parameter'])
        
        footprint = footprintdata_models.Footprints(**validated_data)
        
        footprint.save()
        
        return footprint
    
    def to_representation(self, instance):
        return super().to_representation(instance)

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
                "entries": list(footprints.values('time_of_entry', 'activity', 'type_of_activity', 'parameter', 'carbon_footprint', 'number_of_trees'))
                # manipulation of data will be done by frontend (statistics and graphs)
            }
    
        except Exception as e:
            raise serializers.ValidationError(f"Error: {str(e)}")

    def to_representation(self, instance):

        return self.get_data(self.validated_data)