from rest_framework import status, response, views, permissions

from rest_framework import status
from footprintdata import serializers, models

class InsertDataView(views.APIView):

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, *args, **kwargs):
        
        activity = request.data.get('activity')
        type_of_activity = request.data.get('type_of_activity')
        parameter = request.data.get('parameter')
        
        if not activity:
            return response.Response(
                {"detail": "Activity is required!"},
                status = status.HTTP_400_BAD_REQUEST
            )

        else:

            if not type_of_activity:

                # Step 1: User selects activity, and we return possible types for that activity.

                serializer = serializers.ActivityTypeSerializer(data = request.data)
                
                if serializer.is_valid():

                    activity = request.data.get('activity')

                    types = list(models.data.get('Types').get(str(activity), {}).items())

                    return response.Response({
                        "activity": activity,
                        "types": types,
                        "message": "Select a type."
                    }, status = status.HTTP_200_OK)
                
                return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
            
            else:

                if not parameter:

                    # Step 2: User selects activity and type, and we ask for the parameter.

                    serializer = serializers.TypeParameterSerializer(data = request.data)

                    if serializer.is_valid():

                        activity = request.data.get('activity')
                        type_of_activity = request.data.get('type_of_activity')
                        parameters = str(models.data.get('Parameters').get(str(activity), {}).get(str(type_of_activity), None))

                        return response.Response({
                            "activity": activity,
                            "type_of_activity": type_of_activity,
                            "parameters": parameters,
                            "message": "Provide a parameter."
                        }, status = status.HTTP_200_OK)
                    
                    return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
                
                else:

                    # Step 3: After selecting activity and type, user provides the parameter and calculates carbon footprint.
                    
                    serializer = serializers.FootprintsSerializer(data = request.data, context = {'request': request})

                    if serializer.is_valid():
                        
                        footprint = serializer.save(validated_data = request.data)
                        
                        return response.Response({
                            "message": "Carbon footprint calculated and saved successfully.",
                            "carbon_footprint": footprint.carbon_footprint,
                            "number_of_trees": footprint.number_of_trees
                        }, status = status.HTTP_201_CREATED)

                    return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

        
class ViewDataView(views.APIView):

    permission_classes = [permissions.IsAuthenticated]
    
    def get(self, request, *args, **kwargs):

        user = request.user
        activity = request.query_params.get('activity')
        time_start = request.query_params.get('time_start')
        time_end = request.query_params.get('time_end')

        if not all([user, activity, time_start, time_end]):
            return response.Response(
                {"detail": "Missing required parameters!"},
                status = status.HTTP_400_BAD_REQUEST
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
    
class ShareDataView(views.APIView):

    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):

        sender = request.user
        receiver_username = request.query_params.get('receiver_username') # username
        activity = request.query_params.get('activity')
        time_start = request.query_params.get('time_start')
        time_end = request.query_params.get('time_end')
        message = request.query_params.get('message')

        if not all([sender, receiver_username, activity, time_start, time_end]):
            return response.Response({'detail': "Missing required parameters!"}, status = status.HTTP_400_BAD_REQUEST)
        
        serializer_data = {
            'sender': sender,
            'receiver_username': receiver_username,
            'activity': activity,
            'time_start': time_start,
            'time_end': time_end
        } 
        
        serializer = serializers.FootprintShareSerializer(data = serializer_data)

        serializer.is_valid(raise_exception = True)

        serializer.save()

        data = serializer.get_data(serializer.validated_data)

        return response.Response(data = data, status = status.HTTP_200_OK)