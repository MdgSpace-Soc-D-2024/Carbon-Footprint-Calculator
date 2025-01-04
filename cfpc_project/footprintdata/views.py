from rest_framework import status, response, views, permissions

from rest_framework import status
from footprintdata import serializers, models

class InsertDataView(views.APIView):

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, *args, **kwargs):
        
        activity = request.data.get('activity')
        type_ = request.data.get('type_')
        parameter = request.data.get('parameter')

        if not activity:
            return response.Response(
                {"detail": "Activity is required!"},
                status = status.HTTP_400_BAD_REQUEST
            )

        if activity and not type_:

            # Step 1: User selects activity, and we return possible types for that activity.

            serializer = serializers.ActivityTypeSerializer(data = request.data)
            
            if serializer.is_valid():

                activity = serializer.validated_data['activity']

                types = list(models.data['Types'].get(str(activity), {}).items())

                return response.Response({
                    "activity": activity,
                    "types": types,
                    "message": "Select a type and provide a parameter."
                }, status = status.HTTP_200_OK)
            
            return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
        
        elif activity and type_ and not parameter:

            # Step 2: User selects activity and type, and we ask for the parameter.

            serializer = serializers.TypeParameterSerializer(data = request.data)

            if serializer.is_valid():

                activity = serializer.validated_data['activity']
                type_ = serializer.validated_data['type_']
                parameter = str(models.data['parameters'].get(str(activity), {}).get(str(type_), None))

                return response.Response({
                    "activity": activity,
                    "type": type_,
                    "parameter": parameter,
                    "message": "Provide a parameter."
                }, status = status.HTTP_200_OK)
            
            return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
        
        elif activity and type_ and parameter:

            # Step 3: After selecting activity and type, user provides the parameter and calculates carbon footprint.
            
            serializer = serializers.FootprintsSerializer(data = request.data)

            if serializer.is_valid():
                footprint = serializer.save(user = request.user)
                return response.Response({
                    "message": "Carbon footprint calculated and saved successfully.",
                    "carbon_footprint": footprint.carbon_footprint,
                    "number_of_trees": footprint.number_of_trees
                }, status = status.HTTP_201_CREATED)

            return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

        
class ViewDataView(views.APIView):

    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request, *args, **kwargs):

        user = request.query_params.get('user')
        activity = request.query_params.get('activity')
        time_start = request.query_params.get('time_start')
        time_end = request.query_params.get('time_end')

        if not all([user, activity, time_start, time_end]):
            return response.Response(
                {"detail": "Missing required parameters: user, activity, time_start, and time_end."},
                status=status.HTTP_400_BAD_REQUEST
            ) 
        # later may change this to showing all entries related to the inputs only, i.e. not making it mandatory to provide all.

        serializer_data = {
            'user': user,
            'activity': activity,
            'time_start': time_start,
            'time_end': time_end
        }

        serializer = serializers.FootprintsViewSerializer(data = serializer_data)

        if serializer.is_valid():
            data = serializer.get_data(serializer.validated_data)  # Get the footprint data
            return response.Response(data, status = status.HTTP_200_OK)
        
        return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)