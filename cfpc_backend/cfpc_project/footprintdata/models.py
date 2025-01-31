from django.db import models
from django.utils import timezone
from rest_framework import exceptions

import json

import login.models as login_models

import os

base_dir = os.path.dirname(__file__)

def readData(filename):
    try:
        with open(filename) as f:
            data = json.load(f)
        return data
    except FileNotFoundError:
        raise exceptions.ValidationError(f"{filename} not found.")
    except json.JSONDecodeError:
        raise exceptions.ValidationError(f"Error parsing {filename}.")
    
filename = os.path.join(base_dir, 'data.json')

data = readData(filename)

# The carbon absorption coefficient per tree was derived through two main methods: 
# 1) Reference to literature specifying carbon sequestration and 
# 2) Derivation based on allometric models and coefficients.

# Though it differs for the various species,

# According to World Bank (2020),
# average CO2 emissions per person is 4300000 grams per year
# and an individual needs to plant about 165 trees.
# Hence, the average carbon offset per tree is 4300000/165 = 26060.60606060606 grams per year.

# Can also include data for different trees on the basis of their carbon absorption coefficient, later!

TREE_CARBON_OFFSET = data['TreeCarbonOffset'] # trees required to offset 1 g of CO2

class Footprints(models.Model):
    
    user = models.ForeignKey(login_models.CustomUser, on_delete = models.CASCADE)
    time_of_entry = models.DateTimeField(default = timezone.now)
    activity = models.IntegerField(choices = [(key, value) for key, value in data['Activities'].items()])
    type_of_activity = models.IntegerField() # depends on the activity chosen
    parameter = models.FloatField() # depends on the type chosen
    emission_factor = models.FloatField(null = True)
    carbon_footprint = models.FloatField(null = True)
    number_of_trees = models.FloatField(null = True)

    def __str__(self):
        return f"{self.user} : {self.get_activity_display()} on {self.time_of_entry}"

    def calculate_carbon_footprint(self):

        try:
    
            self.emission_factor = data['EmissionFactors'].get(str(self.activity), {}).get(str(self.type_of_activity), None)

            if self.emission_factor is None:
                raise exceptions.ValidationError(f"No emission factor found for activity {self.activity} and type {self.type_of_activity}.")
            
            self.carbon_footprint = self.emission_factor*self.parameter
            
            return self.carbon_footprint

        except (Exception) as e:
            raise exceptions.ValidationError(f'Error: {str(e)}')

    def calculate_number_of_trees(self):

        if not self.carbon_footprint:
            self.carbon_footprint = self.calculate_carbon_footprint() 
        
        self.number_of_trees = self.carbon_footprint*TREE_CARBON_OFFSET

        return self.number_of_trees 

    def save(self, *args, **kwargs):
        self.carbon_footprint = self.calculate_carbon_footprint()
        self.number_of_trees = self.calculate_number_of_trees()
        super().save(*args, **kwargs)


class SharingModel(models.Model):

    default_message = "Hi, Carbon Footprint Calculator User! I recently recorded a activity and took a step to learning how much my actions mean to the planet. Have a look at it and show your appreciation! Hope we continue using Carbon Footprint Calculator and make our lives better!"

    sender = models.ForeignKey(login_models.CustomUser, on_delete = models.CASCADE, related_name = 'sender')
    receiver =  models.ForeignKey(login_models.CustomUser, on_delete = models.CASCADE, related_name = 'receiver')
    activity_id = models.ForeignKey(Footprints, on_delete = models.CASCADE)
    time_of_sharing = models.DateTimeField(default = timezone.now)
    message = models.CharField(default = default_message, max_length = 500)

    def __str__(self):
        return f"{self.sender} shared {self.activity_id} with {self.receiver} on {self.time_of_sharing}"

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)