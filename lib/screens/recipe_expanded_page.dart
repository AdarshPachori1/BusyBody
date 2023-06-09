import 'package:adarshpachori/models/food.dart';
import 'package:adarshpachori/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeFullPage extends StatefulWidget {
  @override
  State<RecipeFullPage> createState() => _RecipeFullPageState();
  final Food recipeVal;
  const RecipeFullPage({super.key, required this.recipeVal});
}

class _RecipeFullPageState extends State<RecipeFullPage> {
  @override
  Widget build(BuildContext context) {
    final Recipe recipe = widget.recipeVal as Recipe;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Row(
              children: [Icon(Icons.arrow_back), Text("Go Back")],
            ),
          ),
          Text(recipe.name),
          Text(
            "Description: ${recipe.description}",
          ),
          Text("Calories: ${recipe.calories}"),
          Text("URL: ${recipe.url}"),
          Text(
              "Nutritional facts: ${recipe.fat} fats, ${recipe.protein} protein, ${recipe.carbs} carbs"),
        ]),
      ),
    );
  }
}
