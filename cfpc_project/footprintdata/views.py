from rest_framework import status, response, views, permissions

from rest_framework import status
from footprintdata import serializers, models

class InsertDataView(views.APIView):

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, *args, **kwargs):

        # Step 1: User selects activity, and we return possible types for that activity.

        serializer = serializers.ActivityTypeSerializer(data=request.data)
        
        if serializer.is_valid():

            activity_id = serializer.validated_data['activity_id']

            types = list(models.data['Types'].get(str(activity_id), {}).items())

            return response.Response({
                "activity": activity_id,
                "types": types,
                "message": "Select a type and provide a parameter."
            }, status = status.HTTP_200_OK)
        
        return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

    def post1(self, request, *args, **kwargs):
        
        # Step 2: After selecting activity and type, user provides the parameter and calculates carbon footprint.
        
        serializer = serializers.FootprintsSerializer(data = request.data)

        if serializer.is_valid():
            footprint = serializer.save(user = request.user)
            return response.Response({
                "message": "Carbon footprint calculated and saved successfully.",
                "carbon_footprint": footprint.carbon_footprint,
                "number_of_trees": footprint.number_of_trees
            }, status = status.HTTP_201_CREATED)

        return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)