class Footprint{
  int activity;
  int type;
  double parameter;
  
  Footprint({required this.activity, required this.type, required this.parameter});
  
  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'type_of_activity': type,
      'parameter': parameter,
    };
  }
}

class ViewFootprints{
  String activity;
  String start;
  String end;
  
  ViewFootprints({required this.activity, required this.start, required this.end});
  
  Map<String, dynamic> toJson() {
    return {
      'activity': activity,
      'time_start': start,
      'time_end': end,
    };
  }
}

class FootprintEntries {
  String timeOfEntry;
  int activity;
  int type;
  double parameter;
  double carbonFootprint;
  double numberOfTrees;

  FootprintEntries({
    required this.timeOfEntry,
    required this.activity,
    required this.type,
    required this.parameter,
    required this.carbonFootprint,
    required this.numberOfTrees,
  });

  // Factory method to create an object from JSON
  factory FootprintEntries.fromJson(Map<String, dynamic> json) {
    return FootprintEntries(
      timeOfEntry: json['time_of_entry'], 
      activity: json['activity'],
      type: json['type_of_activity'],
      parameter: (json['parameter'] as num).toDouble(),
      carbonFootprint: (json['carbon_footprint'] as num).toDouble(),
      numberOfTrees: (json['number_of_trees'] as num).toDouble(),
    );
  }
}

enum Activity {
  electricity('Electricity'),
  food('Food'),
  internet('Internet'),
  travel('Travel');

  const Activity(this.label);
  final String label;
}

enum Type1 {
  coal('Coal'),
  oil('Oil'),
  naturalGas('Natural Gas'),
  biomass('Biomass'),
  solar('Solar'),
  wind('Wind'),
  hydro('Hydro'),
  nuclear('Nuclear');

  const Type1(this.label);
  final String label;
}

enum Type2 {
  ale('Ale'),
  almonds('Almonds'),
  apples('Apples'),
  apricot('Apricot'),
  asparagus('Asparagus'),
  avocados('Avocados'),
  bacon('Bacon'),
  bananas('Bananas'),
  beans('Beans'),
  beefBurger('Beef Burger'),
  beefCurry('Beef Curry'),
  beefMeatballs('Beef Meatballs'),
  beefNoodles('Beef Noodles'),
  beer('Beer'),
  beetroot('Beetroot'),
  biscuits('Biscuits'),
  bread('Bread'),
  breakfastCereal('Breakfast Cereal'),
  broccoli('Broccoli'),
  butter('Butter'),
  cabbage('Cabbage'),
  carrots('Carrots'),
  cashewnuts('Cashew Nuts'),
  cauliflower('Cauliflower'),
  cheddarCheese('Cheddar Cheese'),
  cheeseCake('Cheese Cake'),
  chickenBurger('Chicken Burger'),
  chickenCurry('Chicken Curry'),
  chickenNoodles('Chicken Noodles'),
  chickenPasta('Chicken Pasta'),
  chickenSausages('Chicken Sausages'),
  chickenThighs('Chicken Thighs'),
  chickenWings('Chicken Wings'),
  chickpeas('Chickpeas'),
  chocolateBiscuits('Chocolate Biscuits'),
  chocolateCake('Chocolate Cake'),
  coconutMilk('Coconut Milk'),
  coffee('Coffee'),
  cookies('Cookies'),
  cottageCheese('Cottage Cheese'),
  cottagePie('Cottage Pie'),
  cowMilk('Cow Milk'),
  cucumber('Cucumber'),
  dairyFreeCheese('Dairy Free Cheese'),
  dairyFreeIceCream('Dairy Free Ice Cream'),
  darkChocolate('Dark Chocolate'),
  doughnuts('Doughnuts'),
  eggs('Eggs'),
  frenchFries('French Fries'),
  fruitCake('Fruit Cake'),
  fruitSmoothies('Fruit Smoothies'),
  gardenPeas('Garden Peas'),
  goatCheese('Goat Cheese'),
  granola('Granola'),
  grapes('Grapes'),
  haddockRisotto('Haddock Risotto'),
  halloumiCheese('Halloumi Cheese'),
  iceCream('Ice Cream'),
  kiwis('Kiwis'),
  lambLeg('Lamb Leg'),
  lambBurgers('Lamb Burgers'),
  lambCasserole('Lamb Casserole'),
  lambCurry('Lamb Curry'),
  lambMoussaka('Lamb Moussaka'),
  lasagneSheets('Lasagne Sheets'),
  lemons('Lemons'),
  lentils('Lentils'),
  lettuce('Lettuce'),
  macaroni('Macaroni'),
  mackerel('Mackerel'),
  meatPizza('Meat Pizza'),
  meatFreeBurger('Meat Free Burger'),
  meatFreeMince('Meat Free Mince'),
  meatFreeNuggets('Meat Free Nuggets'),
  meatFreeSausages('Meat Free Sausages'),
  melon('Melon'),
  milkChocolate('Milk Chocolate'),
  mixedSalad('Mixed Salad'),
  muesli('Muesli'),
  muffins('Muffins'),
  mushrooms('Mushrooms'),
  naan('Naan'),
  nutLoaf('Nut Loaf'),
  onions('Onions'),
  orangeJuice('Orange Juice'),
  oranges('Oranges'),
  pancakes('Pancakes'),
  pasta('Pasta'),
  peanutButter('Peanut Butter'),
  peanuts('Peanuts'),
  pears('Pears'),
  pineapple('Pineapple'),
  popcorn('Popcorn'),
  porridgeOatmeal('Porridge Oatmeal'),
  potatoes('Potatoes'),
  prawns('Prawns'),
  proteinBar('Protein Bar'),
  pumpkinSeeds('Pumpkin Seeds'),
  raspberries('Raspberries'),
  rice('Rice'),
  salmon('Salmon'),
  sausageRolls('Sausage Rolls'),
  soyDesert('Soy Desert'),
  soyMilk('Soy Milk'),
  spaghetti('Spaghetti'),
  spinach('Spinach'),
  spongeCake('Sponge Cake'),
  strawberries('Strawberries'),
  sweetcorn('Sweetcorn'),
  tea('Tea'),
  tofu('Tofu'),
  tomatoes('Tomatoes'),
  tortillaWraps('Tortilla Wraps'),
  vegPizza('Veg Pizza'),
  vegetableLasagne('Vegetable Lasagne'),
  vegCurry('Veg Curry'),
  walnuts('Walnuts'),
  watermelon('Watermelon'),
  wine('Wine'),
  yoghurt('Yoghurt');

  const Type2(this.label);
  final String label;
}

enum Type3 {
  websitePage('Website Page'),
  email('Email'),
  dataStored('Data Stored'),
  googleSearch('Google Search'),
  netflix('Netflix'),
  youtube('Youtube'),
  textMessage('Text Message'),
  tweet('Tweet'),
  tikTok('TikTok'),
  reddit('Reddit'),
  pinterest('Pinterest'),
  instagram('Instagram'),
  snapchat('Snapchat'),
  linkedin('Linkedin'),
  facebook('Facebook'),
  phoneCall('Phone Call');

  const Type3(this.label);
  final String label;
}

enum Type4 {
  domesticFlight('Domestic Flight'),
  dieselCar('Diesel Car'),
  petrolCar('Petrol Car'),
  shortHaulFlight('Short-haul Flight'),
  longHaulFlight('Long Haul Flight'),
  motorbike('Motorbike'),
  bus('Bus'),
  electricCar('Electric Car'),
  rail('Rail');

  const Type4(this.label);
  final String label;
}

final Map<int, List<Enum>> activityTypeMap = {
    1: Type1.values,
    2: Type2.values,
    3: Type3.values,
    4: Type4.values,
};

enum Parameter3 {
  websitePagesVisited('Number of Website Pages Visited'),
  emailsSentReceived('Number of Emails Sent/Received'),
  dataStoredGB('Amount of Data Stored (in GBs)'),
  googleSearches('Number of Google Searches'),
  netflixMinutes('Minutes of Netflix Watched'),
  youtubeMinutes('Minutes of Youtube Watched'),
  textMessages('Number of Text Messages Sent/Received'),
  tweets('Number of Tweets Sent/Received'),
  tikTokMinutes('Minutes of TikTok Watched'),
  redditMinutes('Minutes of Reddit Watched'),
  pinterestMinutes('Minutes of Pinterest Watched'),
  instagramMinutes('Minutes of Instagram Watched'),
  snapchatMinutes('Minutes of Snapchat Watched'),
  linkedinMinutes('Minutes of Linkedin Watched'),
  facebookMinutes('Minutes of Facebook Watched'),
  phoneCalls('Minutes of Phone Calls Made/Received');

  const Parameter3(this.label);
  final String label;
}

final Map<Type3, Parameter3> type3ToParameter3 = {
  Type3.websitePage: Parameter3.websitePagesVisited,
  Type3.email: Parameter3.emailsSentReceived,
  Type3.dataStored: Parameter3.dataStoredGB,
  Type3.googleSearch: Parameter3.googleSearches,
  Type3.netflix: Parameter3.netflixMinutes,
  Type3.youtube: Parameter3.youtubeMinutes,
  Type3.textMessage: Parameter3.textMessages,
  Type3.tweet: Parameter3.tweets,
  Type3.tikTok: Parameter3.tikTokMinutes,
  Type3.reddit: Parameter3.redditMinutes,
  Type3.pinterest: Parameter3.pinterestMinutes,
  Type3.instagram: Parameter3.instagramMinutes,
  Type3.snapchat: Parameter3.snapchatMinutes,
  Type3.linkedin: Parameter3.linkedinMinutes,
  Type3.facebook: Parameter3.facebookMinutes,
  Type3.phoneCall: Parameter3.phoneCalls,
};