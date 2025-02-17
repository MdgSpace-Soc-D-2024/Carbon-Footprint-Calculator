# Carbon-Footprint-Calculator

## Introduction

Knowing your carbon footprint is critical to understanding your impact on the planet and yet there still seems to be some confusion over what it means. A carbon footprint is a certain amount of gaseous emissions that are relevant to climate change and associated with human production or consumption activities. It is an environmental indicator of the volume of greenhouse gases — those gases in our atmosphere that trap and release heat and contribute to climate change. Offsetting the carbon emissions from your lifestyle is a critical step toward fighting climate change.

Humanity’s global carbon footprint is the headline index for climate change. The carbon footprint has been on a soaring trend in the 21st century, with the exception of a brief drop in 2020 because of the COVID-19 lockdown. So, how do we reduce our impact on the Earth?

Individual action on climate change begins from their choices in many areas, such as diet, travel, household energy use, consumption of goods and services, and family size. High-consumption lifestyles have a greater environmental impact, with the richest 10% of people emitting about half the total lifestyle emissions. People who wish to reduce their carbon footprint can take high-impact actions, such as avoiding frequent flying and petrol-fuelled cars, eating a plant-based diet, and avoiding meat and dairy foods. They can engage in local and political advocacy around issues of climate change.

This project is an endeavor to support the cause by providing an approximate of the carbon footprints you generate in your day-to-day activities. It tries to explain the bleak consequence and suggests ways to transform it into a productive influence. Other important factors are endorsed in the imminent pages. This is an elementary version of a product that may take future turns with more details and scientific research along with a user-preferred interface.

*"We're running the most dangerous experiment in history right now, which is to see how much carbon dioxide the atmosphere can handle before there is an environmental catastrophe."*

## Working Rule

GHG emissions are most likely made up of the energy used for electricity and travel, in addition to the energy required to produce food and all the other stuff you buy. These are called direct emissions however, the true carbon footprint of something would take into account all of the indirect emissions of a product, such as the extraction and processing of oil used in manufacture and transport.

Though the entire lifetime’s value of emissions should be taken into account, this project report deals on a very small scale and provides a rough estimate of their carbon footprints to an ordinary user. If it is meant to be considered for any scientific research, modifications may be included in future developments.

The data used here is obtained from [Our World In Data](https://ourworldindata.org/).

The activities which are examined in the report are:
- Electricity Consumption
- Food Consumption
- Activities on Internet
- Travel and Commute

Computational Process

- Takes necessary data from the user using a Flutter frontend.
- Performs calculations as specified in the Python code and the JSON data file to find the weight of carbon footprints (in grams) and number of trees.
- Stores the data in an SQL Database.
- Serializes the data from Django REST Framework to the frontend.
- Displays the carbon footprints and number of trees.

## Future Projections

- Add more activities such as generating waste and also, activities such as walking and planting trees with negative carbon offset.
- Include data for different plants and trees to generate accurate results for number of trees to be planted for a particular activity.
- Introduce feature of blogs for environment conservation.
- Allow sharing the progress among users.

*"There is no footprint so small that it can not leave an impact on the planet."*
