import 'package:adarshpachori/models/user.dart';
import 'package:adarshpachori/models/food.dart';
import 'package:adarshpachori/models/restaurant.dart';
import 'package:adarshpachori/screens/recipe_expanded_page.dart';
import 'package:adarshpachori/screens/restaurant_expanded_page.dart';
import 'package:adarshpachori/models/mutable_values.dart';
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
  String dropdownValueLocation = "Home";
  List<String> dropdownListLocations = <String>["Home", "Away"];

  String dropdownValueGoals = "Losing Weight";
  List<String> dropdownListGoals = <String>[
    "Losing Weight",
    "Bulking",
    "Becoming more Lean"
  ];
  List<Recipe> homeRecipes = [
    Recipe(
        url: "url",
        name: "Enchiladas",
        description: "description of Enchiladas",
        calories: 950,
        protein: 30,
        carbs: 15,
        fat: 5),
    Recipe(
        url: "url",
        name: "Tacos",
        description: "description of Tacos",
        calories: 860,
        protein: 20,
        carbs: 15,
        fat: 5),
    Recipe(
        url: "url",
        name: "Burrito",
        description: "description of Burrito",
        calories: 500,
        protein: 10,
        carbs: 4,
        fat: 4),
    Recipe(
        url: "url",
        name: "Pancakes",
        description: "description of Pancakes",
        calories: 1200,
        protein: 45,
        carbs: 25,
        fat: 10),
  ];

  List<Restaurant> unrankedRestaurants = [
    Restaurant(
        name: "Chic-Fil-A",
        imageUrl: "imageUrl",
        url: "restaurantUrl",
        rating: 5,
        sentimentRating: 4,
        latitude: 110.0,
        longitude: -112.1,
        priceLevel: "\$\$",
        address: "address",
        phone: "phone")
  ];

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

  @override
  Widget build(BuildContext context) {
    double heightOfScreen = MediaQuery.of(context).size.height;
    double widthOfScreen = MediaQuery.of(context).size.width;
    requestPermission();

    // get user desired workout parameters
    final User user = Provider.of<MutableValues>(context, listen: false).user;
    // rank recipes before recommending
    final List<Recipe> rankedRecipes = getRankedRecipes(
        homeRecipes,
        user.desiredCalories,
        user.desiredProtein,
        user.desiredCarbs,
        user.desiredFat);
    // rank restaurants before recommending
    final List<Restaurant> rankedRestaurants =
        getRankedRestaurants(unrankedRestaurants, user.desiredPriceLevel);

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
            child: SingleChildScrollView(
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
      ],
    );
  }
}
