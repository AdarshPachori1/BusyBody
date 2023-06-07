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
    final Recipe castedRecipeVal = widget.recipeVal as Recipe;
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
          Text(castedRecipeVal.name),
          Text(
            "Description: ${castedRecipeVal.description}",
          ),
          Text("Calories: ${castedRecipeVal.calories}"),
        ]),
      ),
    );
  }
}
