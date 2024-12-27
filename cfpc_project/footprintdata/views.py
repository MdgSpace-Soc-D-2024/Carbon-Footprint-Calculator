from django.shortcuts import render, HttpResponse, redirect

def insertdata(response):
    return render(response, "insertdata/insertdata.html", {})

def viewdata(response):
    return render(response, "viewdata/viewdata.html", {})

def sharedata(response):
    return render(response, "sharedata/sharedata.html", {})

def viewshareddata(response):
    return render(response, "viewshareddata/viewshareddata.html", {})