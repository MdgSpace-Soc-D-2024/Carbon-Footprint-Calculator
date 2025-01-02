from rest_framework import status, viewsets, views, permissions, response, decorators

from django.contrib.auth import authenticate
from django.contrib.auth import get_user_model

from rest_framework_simplejwt import tokens

from login import models, serializers, permissions as login_permissions

from django.views.decorators.csrf import csrf_exempt

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
    refresh = tokens.RefreshToken.for_user(user)
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }

class LoginView(views.APIView):
    
    # Handles user login

    permission_classes = [permissions.AllowAny]

    def post(self, request):

        if request.user.is_authenticated:
            return response.Response({'message': 'User is already logged in!'}, status = status.HTTP_400_BAD_REQUEST)
        
        serializer = serializers.LoginSerializer(data = request.data)
        serializer.is_valid(raise_exception = True)

        username = serializer.validated_data['username']
        password = serializer.validated_data['password']

        user = authenticate(username = username, password = password)
        
        if user is None:
            return response.Response({'error': 'Invalid credentials'}, status = status.HTTP_401_UNAUTHORIZED)

        tokens = get_tokens_for_user(user)
        
        return response.Response(tokens, status = status.HTTP_200_OK)

class RegisterView(views.APIView):

    # Handles user registration

    permission_classes = [permissions.AllowAny]

    def post(self, request):
        
        if request.user.is_authenticated:
            return response.Response({'message': 'User is already logged in!'}, status = status.HTTP_400_BAD_REQUEST)
        
        serializer = serializers.RegisterSerializer(data = request.data)

        if serializer.is_valid():
            # username = serializer.validated_data.get('username')
            # password = request.data.get('password')

            # if models.CustomUser.objects.filter(username = username).exists():
            #     return response.Response({'error': 'Username already exists!'}, status = status.HTTP_400_BAD_REQUEST)

            user = serializer.save()

            return response.Response({'message': f'Welcome, {user.username}! Registration with Carbon Footprint Calculator was successful!'}, status = status.HTTP_201_CREATED)
        
        else:
            return response.Response(serializer.errors, status = status.HTTP_400_BAD_REQUEST)

class LogoutView(views.APIView):

    # Handles user logout

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        
        try:
            
            # Get the refresh token from the request (fromtend handles it)
            refresh_token = request.data.get("refresh_token")
            if not refresh_token:
                return response.Response({'error': 'Refresh token is required!'}, status = status.HTTP_400_BAD_REQUEST)
            
            # Blacklist the token
            token = tokens.RefreshToken(refresh_token)
            token.blacklist()

            return response.Response({'message': 'Successfully logged out!'}, status = status.HTTP_200_OK)
        
        except Exception as e:
            return response.Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)