"""
URL configuration for cfpc_project project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path
from footprintdata import views
from django.views.decorators.csrf import csrf_exempt

urlpatterns = [
    path('insertdata/', csrf_exempt(views.InsertDataView.as_view()), name = 'insertdata'),
    path('viewdata/', csrf_exempt(views.ViewDataView.as_view()), name = 'viewdata'),
    path('sharedata/', csrf_exempt(views.ShareDataView.as_view()), name = 'sharedata'),
    path('viewshareddata/', csrf_exempt(views.ViewSharedDataView.as_view()), name = 'viewshareddata')
]
