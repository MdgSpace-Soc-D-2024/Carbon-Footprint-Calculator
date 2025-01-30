from rest_framework import serializers
from login import models as login_models
from footprintdata import models as footprintdata_models
from django.utils import timezone

class HomeSerializer(serializers.Serializer):

    username = serializers.CharField()
    carbon_footprint = serializers.FloatField()
    number_of_trees = serializers.IntegerField()

    def to_representation(self, instance):
        return {
            "username": instance["username"],
            "carbon_footprint": instance["carbon_footprint"],
            "number_of_trees": instance["number_of_trees"],
        }