from rest_framework import views, permissions, status, response

from login import models as login_models
from footprintdata import models as footprintdata_models

from home import serializers

class HomeView(views.APIView):
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def get(self, request, *args, **kwargs):
        user = request.user
        try:
            footprint = footprintdata_models.Footprints.objects.get(user = user)
            serializer = serializers.HomeSerializer(footprint)
            return response.Response(serializer.data)
        except footprintdata_models.Footprints.DoesNotExist:
            return response.Response(
                {
                    "username": user.username,
                    "carbon_footprint": 0.0,
                    "number_of_trees": 0.0,
                },
                status = status.HTTP_200_OK
            )