import 'package:adarshpachori/screens/recipe_expanded_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/recipe.dart';

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
    Recipe(name: "Enchiladas", cookingTime: 30.0, youtubeLink: ""),
    Recipe(name: "Tacos", cookingTime: 10.0, youtubeLink: ""),
    Recipe(name: "Acai Bowl", cookingTime: 15.0, youtubeLink: ""),
    Recipe(name: "Scrambled Eggs", cookingTime: 20.0, youtubeLink: ""),
    Recipe(name: "Pasta", cookingTime: 5.0, youtubeLink: ""),
    Recipe(name: "Burgers", cookingTime: 2.0, youtubeLink: ""),
    Recipe(name: "Paneer Tikka Masala", cookingTime: 1.0, youtubeLink: "")
  ];

  List<Recipe> restaurantFood = [
    Recipe(name: "In-N-Out Double_Double", cookingTime: 30.0, youtubeLink: ""),
    Recipe(name: "Taco Bell Chalupa", cookingTime: 10.0, youtubeLink: ""),
    Recipe(
        name: "Panda Express Orange Chicken",
        cookingTime: 15.0,
        youtubeLink: ""),
    Recipe(
        name: "Charburger from the Habit", cookingTime: 20.0, youtubeLink: ""),
    Recipe(name: "Subway Sandwich", cookingTime: 5.0, youtubeLink: ""),
    Recipe(name: "Acai Bowl from BlueBowl", cookingTime: 2.0, youtubeLink: ""),
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
                        ? homeRecipes
                        : restaurantFood)
                    .map((Recipe recipe) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        RecipeFullPage(recipeVal: recipe),
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
