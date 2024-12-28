from django.shortcuts import render, HttpResponse, redirect

def insertdata(response):
    return render(response, "footprintdata/insertdata.html", {})

def viewdata(response):
    return render(response, "footprintdata/viewdata.html", {})

def sharedata(response):
    return render(response, "footprintdata/sharedata.html", {})

def viewshareddata(response):
    return render(response, "footprintdata/viewshareddata.html", {})