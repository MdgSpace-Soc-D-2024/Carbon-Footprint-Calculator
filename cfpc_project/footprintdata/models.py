from django.db import models

from django.db import models
from django.utils import timezone

from login import models as login_models

class Footprints(models.Model):
    
    class Activities(models.IntegerChoices):
        Electricity = 1,
        Food = 2,
        Internet = 3,
        Travel = 4

    # types:
    class Electricity(models.IntegerChoices):
        # Electricity
        Coal = 1,
        Oil = 2,
        NaturalGas = 3, "Natural Gas"
        Biomass = 4,
        Solar = 5, "Solar Rooftop"
        Wind = 6, "Wind Power"
        Hydro = 7, "Hydropower"
        Nuclear = 8, "Nuclear Energy"
    
    class Food(models.IntegerChoices):
        # Food
        Ale = 1, 
        Almonds = 2, 
        Apples = 3, 
        Apricot = 4, 
        Asparagus = 5, 
        Avocados = 6,
        Bacon = 7, 
        Bananas = 8, 
        Beans = 9, 
        BeefBurger = 10, "Beef Burger"
        BeefCurry = 11, "Beef Curry"
        BeefMeatballs = 12, "Beef Meat Balls"
        BeefNoodles = 13, "Beef Noodles"
        Beer = 14,
        Beetroot = 15, 
        Biscuits = 16, 
        Bread = 17, 
        BreakfastCereal = 18, "Breakfast Cereal"
        Broccoli = 19, 
        Butter = 20, 
        Cabbage = 21, 
        Carrots = 22, 
        Cashewnuts = 23, 
        Cauliflower = 24,
        CheddarCheese = 25, "Cheddar Cheese"
        CheeseCake = 26, "Cheese Cake"
        ChickenBurger = 27, "Chicken Burger"
        ChickenCurry = 28, "Chicken Curry"
        ChickenNoodles = 29, "Chicken Noodles"
        ChickenPasta = 30, "Chicken Pasta"
        ChickenSausages = 31, "Chicken Sausages"
        ChickenThighs = 32, "Chicken Thighs"
        ChickenWings = 33, "Chicken Wings"
        Chickpeas = 34, 
        ChocolateBiscuits = 35, "Chocolate Biscuits"
        ChocolateCake = 36, "Chocolate Cake"
        CoconutMilk = 37, "Coconut Milk"
        Coffee = 38, 
        Cookies = 39, 
        CottageCheese = 40, "Cottage Cheese"
        CottagePie = 41, "Cottage Pie"
        CowMilk = 42, "Cow's Milk"
        Cucumber = 43, 
        DairyFreeCheese = 44, "Dairy-free Cheese"
        DairyFreeIceCream = 45, "Dairy-free Ice-cream"
        DarkChocolate = 46, "Dark Chocolate"
        Doughnuts = 47, 
        Eggs = 48,
        FrenchFries = 49, "French Fries"
        FruitCake = 50, "Fruit Cake"
        FruitSmoothies = 51, "Fruit Smoothies"
        GardenPeas = 52, "Garden Peas"
        GoatCheese = 53, "Goat's Cheese"
        Granola = 54,
        Grapes = 55, 
        HaddockRisotto = 56, "Haddock Risotto"
        HalloumiCheese = 57, "Halloumi Cheese"
        IceCream = 58, "Ice-cream"
        Kiwis = 59, 
        LambLeg = 60, "Lamb (leg)"
        LambBurgers = 61, "Lamb Burgers"
        LambCasserole = 62, "Lamb Casserole"
        LambCurry = 63, "Lamb Curry"
        LambMoussaka = 64, "Lamb Moussaka"
        LasagneSheets = 65, "Lasagne Sheets"
        Lemons = 66,
        Lentils = 67, 
        Lettuce = 68, 
        Macaroni = 69, 
        Mackerel = 70, 
        MeatPizza = 71, "Meat Pizza"
        MeatFreBurger = 72, "Meat-free Burger"
        MeatFreeMince = 73, "Meat-free Mince"
        MeatFreeNuggets = 74, "Meat-free Nuggets"
        MeatFreeSausages = 75, "Meat-free Sausages"
        Melon = 76, 
        MilkChocolate = 77, "Milk Chocolate"
        MixedSalad = 78, "Mixed Salad"
        Muesli = 79, 
        Muffins = 80, 
        Mushrooms = 81, 
        Naan = 82, 
        NutLoaf = 83, 
        Onions = 84, 
        OrangeJuice = 85, "Orange Juice"
        Oranges = 86, 
        Pancakes = 87, 
        Pasta = 88, 
        PeanutButter = 89, "Peanut Butter"
        Peanuts = 90,
        Pears = 91, 
        Pineapple = 92, 
        Popcorn = 93, 
        PorridgeOatmeal = 94, "Porridge (oatmeal)"
        Potatoes = 95, 
        Prawns = 96,
        ProteinBar = 97, "Protein Bar"
        PumpkinSeeds = 98, "Pumpkin Seeds"
        Raspberries = 99, 
        Rice = 100, 
        Salmon = 101, 
        SausageRolls = 102, "Sausage Rolls"
        SoyDesert = 103, "Soy Desert"
        SoyMilk = 104, "Soy Milk"
        Spaghetti = 105, 
        Spinach = 106, 
        SpongeCake = 107, "Sponge Cake"
        Strawberries = 108,
        Sweetcorn = 109, 
        Tea = 110, 
        Tofu = 111,
        Tomatoes = 112,
        TortillaWraps = 113, "Tortilla Wraps"
        VegPizza = 114, "Vegan Pizza"
        VegetableLasagne = 115, "Vegetable Lasagne"
        VegCurry = 116, "Vegetarian Curry"
        Walnuts = 117, 
        Watermelon = 118, 
        Wine = 119, 
        Yoghurt = 120
    
    class Internet(models.IntegerChoices):
        # Internet
        WebsitePage = 1,
        Email = 2,
        DataStored = 3,
        GoogleSearch = 4,
        Netflix = 5,
        Youtube = 6,
        TextMessage = 7,
        Tweet = 8,
        TikTok = 9,
        Reddit = 10,
        Pinterest = 11,
        Instagram = 12,
        Snapchat = 13,
        Linkedin = 14,
        Facebook = 15,
        PhoneCall = 16
        
    class Travel(models.IntegerChoices):
        # Travel
        DomesticFlight = 1,
        DieselCar = 2,
        PetrolCar = 3,
        ShortHaulFlight = 4,
        LongHaulFlight = 5,
        Motorbike = 7,
        Bus = 8,
        ElectricCar = 9,
        Rail = 10

    
    emissionFactor = {
        'Electricity': {
            'Coal': 1020.58283,
            'Oil':648.637089,
            'NaturalGas':390.089438,
            'Biomass':230,
            'Solar':41,
            'Wind':11,
            'Hydro':24,
            'Nuclear':21,
        },
        'Food': {
            'Ale': 0.48869, 'Almonds': 0.602368, 'Apples': 0.507354, 'Apricot': 1.382105, 'Asparagus': 0.925692, 'Avocados': 0.921227,
            'Bacon': 19.31421, 'Bananas': 0.87335, 'Beans': 1.373308, 'BeefBurger': 53.97637, 'BeefCurry': 17.36872, 'BeefMeatballs': 70.78747,
            'BeefNoodles': 2.290114, 'Beer': 0.686283, 'Beetroot': 2.658241, 'Biscuits': 3.989251, 'Bread': 0.878761, 'BreakfastCereal': 1.493427,
            'Broccoli': 0.897402, 'Butter': 3.324503, 'Cabbage': 0.890284, 'Carrots': 0.935163, 'Cashewnuts': 2.087644, 'Cauliflower': 0.891726,
            'CheddarCheese': 20.74904, 'CheeseCake': 2.369302, 'ChickenBurger': 5.434487, 'ChickenCurry': 3.616546, 'ChickenNoodles': 2.383996,
            'ChickenPasta': 2.946765, 'ChickenSausages': 8.164302, 'ChickenThighs': 9.981881, 'ChickenWings': 9.583456, 'Chickpeas': 1.344353,
            'ChocolateBiscuits': 5.083679, 'ChocolateCake': 3.952118, 'CoconutMilk': 3.31999, 'Coffee': 16.82461, 'Cookies': 3.357278,
            'CottageCheese': 25.2785, 'CottagePie': 11.85127, "Cow's Milk": 3.703237, 'Cucumber': 0.847114, 'DairyFreeCheese': 1.976174,
            'DairyFreeIceCream': 2.451197, 'DarkChocolate': 20.62004, 'Doughnuts': 2.199665, 'Eggs': 4.4366, 'FrenchFries': 0.753472,
            'FruitCake': 3.452116, 'FruitSmoothies': 1.648915, 'GardenPeas': 1.003837, "Goat's Cheese": 19.31207, 'Granola': 1.781193,
            'Grapes': 8.278876, 'HaddockRisotto': 4.898891, 'HalloumiCheese': 16.17245, 'IceCream': 3.661809, 'Kiwis': 1.613707,
            'LambLeg': 30.74095, 'LambBurgers': 26.92829, 'LambCasserole': 30.87731, 'LambCurry': 10.19256, 'LambMoussaka': 7.259162,
            'LasagneSheets': 1.961382, 'Lemons': 0.470153, 'Lentils': 2.53652, 'Lettuce': 4.926023, 'Macaroni': 16.84931, 'Mackerel': 13.60638,
            'MeatPizza': 7.40066, 'MeatFreBurger': 1.018329, 'MeatFreeMince': 0.877038, 'MeatFreeNuggets': 0.861847, 'MeatFreeSausages': 0.962558,
            'Melon': 1.056536, 'MilkChocolate': 10.80027, 'MixedSalad': 0.9209, 'Muesli': 2.271911, 'Muffins': 2.583631, 'Mushrooms': 2.352917,
            'Naan': 1.013234, 'NutLoaf': 0.716131, 'Onions': 0.36286, 'OrangeJuice': 0.488848, 'Oranges': 0.46655, 'Pancakes': 1.547809,
            'Pasta': 1.646015, 'PeanutButter': 3.43496, 'Peanuts': 3.146227, 'Pears': 0.925555, 'Pineapple': 0.932008, 'Popcorn': 1.813626,
            'PorridgeOatmeal': 1.555169, 'Potatoes': 0.207276, 'Prawns': 20.91128, 'ProteinBar': 3.372851, 'PumpkinSeeds': 1.323975,
            'Raspberries': 8.370972, 'Rice': 3.92591, 'Salmon': 10.41258, 'SausageRolls': 5.849549, 'SoyDesert': 1.087264, 'SoyMilk': 0.893108,
            'Spaghetti': 1.646015, 'Spinach': 1.009128, 'SpongeCake': 1.877448, 'Strawberries': 3.241715, 'Sweetcorn': 0.971203,
            'Tea': 17.62104, 'Tofu': 1.020865, 'Tomatoes': 2.271515, 'TortillaWraps': 0.948584, 'VegPizza': 1.948104, 'VegetableLasagne': 3.376141,
            'VegCurry': 1.309165, 'Walnuts': 2.416308, 'Watermelon': 0.969403, 'Wine': 1.722881, 'Yoghurt': 3.111811
        },
        'Internet': {
            'WebsitePage': 1.76, 'Email': 4, 'DataStored': 2800, 'GoogleSearch': 0.2, 
            'Netflix': 51, 'Youtube': 0.44, 'TextMessage': 0.01, 'Tweet': 0.02, 
            'TikTok': 2.63, 'Reddit': 2.48, 'Pinterest': 1.3, 'Instagram':1.05,
            'Snapchat': 0.87, 'Linkedin': 0.79, 'Facebook': 0.71, 'PhoneCall': 0.1
        },
        'Travel': {
            'DomesticFlight': 246, 'DieselCar': 171, 'PetrolCar': 170, 
            'Short-haul Flight':151, 'LongHaulFlight': 148, 'Motorbike': 114, 
            'Bus': 97, 'ElectricCar': 47, 'Rail': 35
        }
    }

    user = models.ForeignKey(login_models.CustomUser, on_delete = models.CASCADE)
    time_of_entry = models.DateTimeField(default = timezone.now)
    activity = models.IntegerField(choices = Activities)
    type = models.IntegerField()
    parameter = models.IntegerField()
    carbon_footprint = models.FloatField()
    number_of_trees = models.FloatField()
    
    def __str__(self):
        return f"{self.user} : {self.get_activity_display()} on {self.time_of_entry}"
    
    @staticmethod
    def get_total_carbon_footprint_for_user(user):
        return Footprints.objects.filter(user=user).aggregate(models.Sum('carbon_footprint'))['carbon_footprint__sum']
    
    def calculate_carbon_footprint(self):
        
        carbon_footprint = self.emissionFactor[self.activity][self.type]*self.parameter
        
        return carbon_footprint

    def calculate_number_of_trees(self):

        # The carbon absorption coefficient per tree was derived through two main methods: 
        # 1) Reference to literature specifying carbon sequestration and 
        # 2) Derivation based on allometric models and coefficients.

        # Though it differs for the various species,

        # According to World Bank (2020),
        # average CO2 emissions per person is 4300000 grams per year
        # and an individual needs to plant about 165 trees.
        # Hence,

        tree_carbon_offset = 165/4300000 # in trees/g
        return self.carbon_footprint*tree_carbon_offset

    def save(self, *args, **kwargs):
        self.carbon_footprint = self.calculate_carbon_footprint()
        self.number_of_trees = self.calculate_number_of_trees()
        super().save(*args, **kwargs)