from rest_framework import permissions

class IsOwnUserOrReadOnly(permissions.BasePermission):
    
    # Custom permission to only allow the user to view or edit their own data.
    
    def has_object_permission(self, request, view, obj):
        
        if request.method in permissions.SAFE_METHODS: # 'GET', 'HEAD', 'OPTIONS'
            return True

        # Write permissions are allowed only if the user is the owner
        return obj == request.user