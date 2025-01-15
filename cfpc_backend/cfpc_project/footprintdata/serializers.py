from rest_framework import serializers
from footprintdata import models as footprintdata_models
from login import models as login_models

from django.db import models

from django.utils import timezone

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

        try:
            validated_data['user'] = self.context['request'].user
        except Exception as e:
            
            serializers.ValidationError("Error: {e}")
        
        validated_data['activity'] = int(validated_data.get('activity'))
        validated_data['type_of_activity'] = int(validated_data.get('type_of_activity'))
        validated_data['parameter'] = float(validated_data.get('parameter'))
        
        footprint = footprintdata_models.Footprints(validated_data)
        
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
        
        if data1['activity'] not in data['Activities'].values():
            raise serializers.ValidationError("Invalid activity!")
        
        footprints = footprintdata_models.Footprints.objects.select_related('user').filter(
                data1['user'],
                activity = data1['activity'],
                time_of_entry__range = (data1['time_start'], data1['time_end'])
            )
        if not footprints.exists():
            raise serializers.ValidationError("No activity found within the given time frame.")
        
        return data1
    
    def get_data(self, validated_data):
        user = validated_data['user']
        activity = validated_data['activity']
        time_start = validated_data['time_start']
        time_end = validated_data['time_end']

        footprints = footprintdata_models.Footprints.objects.select_related('user').filter(user = user, activity = activity, time_of_entry__range = (time_start, time_end))

        return {
            "entries": list(footprints.values('time_of_entry', 'activity', 'type_of_activity', 'parameter', 'carbon_footprint', 'number_of_trees'))
            # manipulation of data will be done by frontend (statistics and graphs)
        }

    def to_representation(self, instance):

        return self.get_data(self.validated_data)
    

# Serializers for sharing data

class FootprintShareSerializer(serializers.Serializer):
    
    sender = serializers.PrimaryKeyRelatedField(queryset = login_models.CustomUser.objects.all())
    receiver = serializers.CharField()
    message = serializers.CharField(required = False)
    time_start = serializers.DateTimeField()
    time_end = serializers.DateTimeField()
    activity = serializers.IntegerField()


    def validate(self, data1):

        sender = data1.get('sender')
        receiver_username = data1.get('receiver_username')
        activity = data1.get('activity')
        time_start = data1.get('time_start')
        time_end = data1.get('time_end')

        try:
            receiver = login_models.CustomUser.objects.get(username = receiver_username)
        except login_models.CustomUser.DoesNotExist:
            raise serializers.ValidationError("Receiver user does not exist.")
        
        if time_start >= time_end:
            raise serializers.ValidationError("Invalid time range!")
        
        if activity not in data['Activities'].values():
            raise serializers.ValidationError("Invalid activity!")
        
        footprints = footprintdata_models.Footprints.objects.select_related('user').filter(user = sender, activity = activity, time_of_entry__range = (time_start, time_end))
        if not footprints.exists():
            raise serializers.ValidationError("No activity found within the given time frame.")
        
        return data1

    def get_data(self, validated_data):
        sender = validated_data.get('sender')
        receiver_username = validated_data.get('receiver_username')
        activity = validated_data.get('activity')
        time_start = validated_data.get('time_start')
        time_end = validated_data.get('time_end')
        message = validated_data.get('message', footprintdata_models.SharingModel.default_message)

        footprints = footprintdata_models.Footprints.objects.select_related('user').filter(user = sender, activity = activity, time_of_entry__range = (time_start, time_end))

        return {
            'entries': list(footprints.values('time_of_entry', 'activity', 'type_of_activity', 'parameter', 'carbon_footprint', 'number_of_trees')), 
            'receiver': receiver_username,
            'message': message
            }

    def save(self):

        sender = self.validated_data.get('sender')
        
        receiver_username = self.validated_data.get('receiver_username')
        
        activity = self.validated_data.get('activity')
        
        time_start = self.validated_data.get('time_start')
        time_end = self.validated_data.get('time_end')
        
        message = self.validated_data.get('message', footprintdata_models.SharingModel.default_message)
        
        receiver = login_models.CustomUser.objects.get(username=receiver_username)

        footprints = footprintdata_models.Footprints.objects.filter(
            user = sender,
            activity = activity,
            time_of_entry__range = (time_start, time_end)
        )

        sharing_instances = []
        for footprint in footprints:
            sharing_instance = footprintdata_models.SharingModel(
                sender = sender,
                receiver = receiver,
                activity_id = footprint,
                time_of_sharing = timezone.now(),
                message = message
            )
            sharing_instances.append(sharing_instance)

        # Bulk save all sharing instances
        footprintdata_models.SharingModel.objects.bulk_create(sharing_instances)

        # Return the created data
        return {"detail": f"Successfully shared {len(sharing_instances)} activities."}

    def to_representation(self, instance):
        return super().to_representation(instance)
    
class FootprintsViewSharedSerializer(serializers.Serializer):

    receiver = serializers.PrimaryKeyRelatedField(queryset = login_models.CustomUser.objects.all())

    def validate(self, data):
        return data

    def get_data(self, validated_data):
        
        receiver = validated_data['receiver']

        shareddata = footprintdata_models.SharingModel.objects.select_related('sender', 'activity_id').filter(receiver = receiver)

        shareddata = list(shareddata.values('sender__username', 'time_of_entry', 'activity_id__activity', 'activity_id__carbonfootprint', 'activity_id__time_of_entry', 'message'))

        return shareddata

    def to_representation(self, instance):
        return super().to_representation(instance)