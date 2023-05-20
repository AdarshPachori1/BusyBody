import 'package:adarshpachori/models/recipe.dart';
import 'package:flutter/material.dart';

class RecipeFullPage extends StatefulWidget {
  @override
  State<RecipeFullPage> createState() => _RecipeFullPageState();
  final Recipe recipeVal;
  const RecipeFullPage({super.key, required this.recipeVal});
}

class _RecipeFullPageState extends State<RecipeFullPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: const [Icon(Icons.arrow_back), Text("Go Back")],
            ),
          ),
          Text(widget.recipeVal.name),
          Text(
            "Duration: ${widget.recipeVal.cookingTime.toString()}",
          ),
          Text("Youtube Link: ${widget.recipeVal.youtubeLink}"),
        ]),
      ),
    );
  }
}
