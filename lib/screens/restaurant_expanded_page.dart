import 'package:adarshpachori/models/food.dart';
import 'package:adarshpachori/models/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantFullPage extends StatefulWidget {
  @override
  State<RestaurantFullPage> createState() => _RecipeFullPageState();
  final Food restaurant;
  const RestaurantFullPage({super.key, required this.restaurant});
}

class _RecipeFullPageState extends State<RestaurantFullPage> {
  @override
  Widget build(BuildContext context) {
    final Restaurant castedRestaurant = widget.restaurant as Restaurant;
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
          Text(castedRestaurant.name),
          Text(
            "Address: ${castedRestaurant.address}",
          ),
          Text("Phone: ${castedRestaurant.phone}"),
        ]),
      ),
    );
  }
}
