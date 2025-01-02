from django.db import models
from django.utils import timezone
from rest_framework import exceptions

import json

from login import models as login_models

def readData(filename):
    with open(filename) as f:
        data = json.load(f)
    return data

data = readData('footprintdata/data.json')

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
    type = models.IntegerField() # depends on the activity chosen
    parameter = models.IntegerField() # depends on the type chosen
    emission_factor = models.FloatField(null = True)
    carbon_footprint = models.FloatField(null = True)
    number_of_trees = models.FloatField(null = True)

    def __str__(self):
        return f"{self.user} : {self.get_activity_display()} on {self.time_of_entry}"
    
    @staticmethod
    def get_total_carbon_footprint_for_user(user):
        return Footprints.objects.filter(user = user).aggregate(models.Sum('carbon_footprint'))['carbon_footprint__sum'] # value in the dictionary returned by Django aggregation methods
    
    def calculate_carbon_footprint(self):

        try:
    
            self.emission_factor = data['EmissionFactors'].get(str(self.activity), {}).get(str(self.type), None)
            
            carbon_footprint = self.emission_factor*self.parameter
            
            return carbon_footprint

        except Exception as e:
            raise exceptions.ValidationError(f'Error: {str(e)}')

    def calculate_number_of_trees(self):

        return self.carbon_footprint*TREE_CARBON_OFFSET

    def save(self, *args, **kwargs):
        self.carbon_footprint = self.calculate_carbon_footprint()
        self.number_of_trees = self.calculate_number_of_trees()
        super().save(*args, **kwargs)

    