from rest_framework import views, permissions, status, response

from login import models as login_models
from footprintdata import models as footprintdata_models

from django.db.models import Sum

class HomeView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        try:
            footprint = footprintdata_models.Footprints.objects.select_related('user').filter(user=user).aggregate(
            total_carbon_footprint = Sum('carbon_footprint'),
            total_number_of_trees = Sum('number_of_trees')
        )
            return response.Response({'username': user.username, 'total_carbon_footprints': footprint['total_carbon_footprint'] or 0.0, 'total_number_of_trees': footprint['total_number_of_trees'] or 0}, status = status.HTTP_200_OK)
        except footprintdata_models.Footprints.DoesNotExist:
            return response.Response(
                {
                    "username": user.username,
                    "total_carbon_footprints": 0.0,
                    "total_number_of_trees": 0.0,
                },
                status = status.HTTP_200_OK
            )