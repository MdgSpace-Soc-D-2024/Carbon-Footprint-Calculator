from rest_framework import serializers
from footprintdata import models as footprintdata_models

data = footprintdata_models.data

class ActivityTypeSerializer(serializers.Serializer):
    
    activity_id = serializers.IntegerField()

    def validate_activity_id(self, activity_id):

        if activity_id not in [int(i) for i in data['Activities'].values()]:
            raise serializers.ValidationError("Invalid activity selected!")
        
        return activity_id

    def to_representation(self, instance):
        
        activity_id = self.validated_data.get('activity_id')
        
        types = list(data['Types'].get(str(activity_id), {}).items())
        
        return {'types': types}

class FootprintsSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = footprintdata_models.Footprints
        fields = ['user', 'activity', 'type', 'parameter']

    def validate(self, data1):
        activity = data1['activity']
        type = data1['type']

        if str(activity) not in data['EmissionFactors']:
            raise serializers.ValidationError("Invalid emission factor for activity.")
        
        if str(type) not in data['EmissionFactors'][str(activity)]:
            raise serializers.ValidationError("Invalid emission factor for the selected type.")
        
        return data1
    
    def validate_parameter(self, value):
        if value <= 0:
            raise serializers.ValidationError("Parameter must be a positive number.")
        return value

    def create(self, validated_data):
        # Calculate and save the carbon footprint after creating the object
        
        footprint = footprintdata_models.Footprints(**validated_data)
        
        footprint.save()
        
        return footprint

