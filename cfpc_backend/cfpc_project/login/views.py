from rest_framework import status, viewsets, views, permissions, response, decorators

from django.contrib.auth import authenticate, get_user_model

from rest_framework_simplejwt import tokens
from rest_framework_simplejwt.settings import api_settings

from login import models, serializers, permissions as login_permissions

import datetime

from django.conf import settings

User = get_user_model()

class CustomUserViewSet(viewsets.ModelViewSet):
    queryset = models.CustomUser.objects.all()
    serializer_class = serializers.CustomUserSerializer

    permission_classes = [permissions.IsAuthenticated, login_permissions.IsOwnUserOrReadOnly]

    @decorators.action(detail=False, methods=['put'])
    def update_profile(self, request):
        user = request.user
        serializer = self.get_serializer(user, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save()
            return response.Response(serializer.data)
        return response.Response(serializer.errors, status=400)


# Helper function to generate JWT tokens for a user
def get_tokens_for_user(user):
    if not hasattr(user, 'username'):
        raise AttributeError("CustomUser object does not have 'username' attribute")
    
    refresh = tokens.RefreshToken.for_user(user)
    
    # The access token can be accessed from the refresh token
    return {
        'access': str(refresh.access_token),
        'refresh': str(refresh),
    }


class LoginView(views.APIView):
    
    # Handles user login

    permission_classes = [permissions.AllowAny]

    def post(self, request):

        if request.user.is_authenticated:
            return response.Response({'message': 'User is already logged in!'}, status = status.HTTP_409_CONFLICT)
        
        serializer = serializers.LoginSerializer(data = request.data)
        serializer.is_valid(raise_exception = True)

        username = serializer.validated_data['username']
        password = serializer.validated_data['password']

        user = authenticate(username = username, password = password) # calls the check_password() method and takes care of hashing therein!
        
        if user is None:
            return response.Response({'error': 'Invalid credentials'}, status = status.HTTP_401_UNAUTHORIZED)

        tokens = get_tokens_for_user(user)
        
        return response.Response(tokens, status = status.HTTP_200_OK)

class RegisterView(views.APIView):

    # Handles user registration

    permission_classes = [permissions.AllowAny]

    def post(self, request):
        
        if request.user.is_authenticated:
            return response.Response({'message': 'User is already logged in!'}, status = status.HTTP_409_CONFLICT)
        
        serializer = serializers.RegisterSerializer(data = request.data)

        serializer.is_valid(raise_exception = True)

        user = serializer.save()

        return response.Response({'message': f'Welcome, {user.username}! Registration with Carbon Footprint Calculator was successful! Login to add your activities!'}, 
                                 user = serializer.to_representation(),
                                 status = status.HTTP_201_CREATED)

class LogoutView(views.APIView):

    # Handles user logout

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        
        try:
            
            # Get the refresh token from the request (frontend handles it)
            refresh_token = request.data.get("refresh_token")
            if not refresh_token:
                return response.Response({'error': 'Refresh token is required!'}, status = status.HTTP_400_BAD_REQUEST)
            
            # Blacklist the token
            token = tokens.RefreshToken(refresh_token)
            token.blacklist()

            return response.Response({'message': 'Successfully logged out!'}, status = status.HTTP_200_OK)
        
        except Exception as e:
            return response.Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)