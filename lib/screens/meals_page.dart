import 'package:adarshpachori/models/user.dart';
import 'package:adarshpachori/models/food.dart';
import 'package:adarshpachori/models/restaurant.dart';
import 'package:adarshpachori/screens/recipe_expanded_page.dart';
import 'package:adarshpachori/screens/restaurant_expanded_page.dart';
import 'package:adarshpachori/models/mutable_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

/// Get numerical representation for dollar sign "$" price level
int getNumForPriceLevel(String priceLevel) {
  /// Price level should be between "$" and "$$$$$"
  switch (priceLevel) {
    case "\$":
      return 1;
    case "\$\$":
      return 2;
    case "\$\$\$":
      return 3;
    case "\$\$\$\$":
      return 4;
    case "\$\$\$\$\$":
      return 5;
    default:
      return 0;
  }
}

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String dropdownValueLocation = "Home";
  List<String> dropdownListLocations = <String>["Home", "Away"];

  String dropdownValueGoals = "Losing Weight";
  List<String> dropdownListGoals = <String>[
    "Losing Weight",
    "Bulking",
    "Becoming more Lean"
  ];
  List<Recipe> homeRecipes = [];
  List<Restaurant> unrankedRestaurants = [];
  List<Recipe> rankedRecipes = [];
  List<Restaurant> rankedRestaurants = [];
  bool runOnce = false;
  void requestPermission() async {
    bool _serviceEnabled;
    LocationPermission _permissionGranted;
    LocationPermission _permission;

    await Geolocator.isLocationServiceEnabled().then((serviceEnabled) async {
      if (!serviceEnabled) {
        // Location service is not enabled on the device
        return;
      }

      await Geolocator.checkPermission().then((permission) async {
        if (permission == LocationPermission.denied) {
          await Geolocator.requestPermission()
              .then((LocationPermission permissionGranted) {
            print(permissionGranted);
            if (permissionGranted == LocationPermission.always) {
              print("Permission Granted Always");
              // Location permission is not granted
              return;
            }
            if (permission == LocationPermission.deniedForever) {
              // Location permission is denied forever, handle accordingly
              print("Permission Denied Always");
              return;
            }
          });
        }
      });
    });
  }

  void loadRecipesAndRestaurants(User user) async {
    await firestore.collection('recipes').get().then((value) {
      List<Recipe> elements_recipes = value.docs
          .map(
            (recipe) => Recipe(
              url: recipe['url'],
              name: recipe['name'],
              description: recipe['description'],
              calories: recipe['calories'],
              protein: recipe['protein'],
              carbs: recipe['carbs'],
              fat: recipe['fat'],
            ),
          )
          .toList();
      print("recipes: $elements_recipes");

      setState(() {
        homeRecipes = elements_recipes;
        rankedRecipes = getRankedRecipes(homeRecipes, user.desiredCalories,
            user.desiredProtein, user.desiredCarbs, user.desiredFat);
      });
    });
    await firestore.collection('restaurants').get().then((value) {
      List<Restaurant> elements_restaurants = value.docs
          .map(
            (restaurant) => Restaurant(
              name: restaurant['name'],
              imageUrl: restaurant['imageUrl'],
              url: restaurant['url'],
              rating: restaurant['rating'],
              sentimentRating: restaurant['sentimentRating'],
              latitude: restaurant['latitude'],
              longitude: restaurant['longitude'],
              priceLevel: restaurant['priceLevel'],
              address: restaurant['address'],
              phone: restaurant['phone'],
            ),
          )
          .toList();
      print("restaurants: $elements_restaurants");
      setState(() {
        unrankedRestaurants = elements_restaurants;
        rankedRestaurants =
            getRankedRestaurants(unrankedRestaurants, user.desiredPriceLevel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightOfScreen = MediaQuery.of(context).size.height;
    double widthOfScreen = MediaQuery.of(context).size.width;
    requestPermission();
    // get user desired workout parameters
    // rank recipes before recommending

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You are at home: "),
            DropdownButton<String>(
              value: dropdownValueLocation,
              icon: const Icon(Icons.arrow_downward),
              items: dropdownListLocations
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  dropdownValueLocation = val!;
                });
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Your Goal: "),
            DropdownButton<String>(
              value: dropdownValueGoals,
              icon: const Icon(Icons.arrow_downward),
              items: dropdownListGoals
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  dropdownValueGoals = val!;
                });
              },
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 30,
          child: (dropdownValueLocation == "Home")
              ? const Text("\t\t\tRecipe Recommendations")
              : const Text("\t\t\t Restaurant Recommendations"),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          height: 0.55 * heightOfScreen,
          width: 0.9 * widthOfScreen,
          child: (dropdownValueLocation == "Home")
              ? StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('recipes').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    List<QueryDocumentSnapshot> documentsRecipes =
                        snapshot.data!.docs;

                    List<Recipe> unrankedRecipes =
                        documentsRecipes.map((recipe) {
                      return Recipe(
                        url: recipe['url'],
                        name: recipe['title'],
                        description: recipe['desc'],
                        calories: recipe['calories'],
                        protein: recipe['protein'],
                        carbs: recipe['carbs'],
                        fat: recipe['fat'],
                      );
                    }).toList();

                    // get user desired workout parameters
                    final User user =
                        Provider.of<MutableValues>(context, listen: false).user;
                    List<Recipe> rankedRecipes = getRankedRecipes(
                      unrankedRecipes,
                      user.desiredCalories,
                      user.desiredProtein,
                      user.desiredCarbs,
                      user.desiredFat,
                    );

                    return ListView.builder(
                      itemCount: rankedRecipes.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Build your widget using the data
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        RecipeFullPage(
                                            recipeVal: rankedRecipes[index]),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 0.1 * heightOfScreen,
                            width: 0.9 * widthOfScreen,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(rankedRecipes[index].name),
                          ),
                        );
                      },
                    );
                  },
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('restaurants').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    List<QueryDocumentSnapshot> documentsRestaurants =
                        snapshot.data!.docs;

                    List<Restaurant> unrankedRestaurants =
                        documentsRestaurants.map((restaurant) {
                      return Restaurant(
                          name: restaurant['name'],
                          imageUrl: restaurant['image_url'] ?? "",
                          url: restaurant['url'] ?? "",
                          rating: restaurant['rating'] ?? 0,
                          sentimentRating: restaurant['sentiment_rating'] ?? 0,
                          latitude: restaurant['coordinates']['latitude'] ?? 0,
                          longitude:
                              restaurant['coordinates']['longitude'] ?? 0,
                          priceLevel: restaurant['price_level'] ?? "",
                          address: restaurant['address'],
                          phone: restaurant['phone']);
                    }).toList();

                    // get user desired workout parameters
                    final User user =
                        Provider.of<MutableValues>(context, listen: false).user;
                    List<Restaurant> rankedRestaurants = getRankedRestaurants(
                        unrankedRestaurants, user.desiredPriceLevel);

                    return ListView.builder(
                      itemCount: rankedRestaurants.length,
                      itemBuilder: (BuildContext context, int index) {
                        // Build your widget using the data
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    RestaurantFullPage(
                                        restaurant: rankedRestaurants[index]),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 0.1 * heightOfScreen,
                            width: 0.9 * widthOfScreen,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(rankedRestaurants[index].name),
                          ),
                        );
                      },
                    );
                  },
                ),
        )
        /*SingleChildScrollView(
              child: Column(
                children: (dropdownValueLocation == "Home"
                        ? rankedRecipes
                        : rankedRestaurants)
                    .map((Food recipe) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        (dropdownValueLocation == "Home"
                                            ? RecipeFullPage(recipeVal: recipe)
                                            : RestaurantFullPage(
                                                restaurant: recipe)),
                                // RecipeFullPage(recipeVal: recipe),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 0.1 * heightOfScreen,
                            width: 0.9 * widthOfScreen,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(recipe.name),
                          ),
                        ))
                    .toList(),
              ),
            ))
      */
      ],
    );
  }
}
