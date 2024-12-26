from django.shortcuts import render, HttpResponse, redirect

from django.contrib.auth import authenticate, login as auth_login, get_user_model
from django.contrib import messages

from login import models, forms

User = get_user_model()

def login(request):

    if request.method == 'POST':

        try:

            form = forms.LoginForm(request.POST)

            if form.is_valid():
                
                user = authenticate(username = form.cleaned_data['username'], password = form.cleaned_data['password'])
                
                if user is not None:
                    auth_login(request, user)
                    return redirect('trying_it_out')
                else:
                    messages.error(request, "Invalid username or password!")
                    return redirect('login')
        
        except Exception as e:
            messages.error(request, f"An unexpected error occurred: {e}")
            return redirect('login')

    form = forms.LoginForm()

    return render(request, 'login/Login.html', {'form': form})

def register(request):
    
    if request.method == 'POST':

        try:

            form = forms.RegisterForm(request.POST)

            username = form.cleaned_data['username']
            password = form.cleaned_data['password']

            if not username or not password:
                messages.error(request, "Username or password cannot be empty!")
                return redirect('register')
            
            if models.User.objects.filter(username = username).exists():
                messages.error(request, "Username already exists.")
                return redirect('register')
            
            if form.is_valid():
                form.save()
                messages.success(request, "Registration with Carbon Footprint Calculator was successful!")
                return redirect('trying_it_out')
            
            return redirect('register')
        
        except Exception as e:
            messages.error(request, f"An unexpected error occurred: {e}")
            return redirect('register')
    
    form = forms.RegisterForm()

    return render(request, 'login/Register.html', {'form': form})

def trying_it_out(request):
    return HttpResponse("Hello!")