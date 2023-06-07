import 'package:adarshpachori/models/mutable_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Profile Page"),
        Text(
            "First Name: ${Provider.of<MutableValues>(context, listen: false).user.firstName} \nLast Name: ${Provider.of<MutableValues>(context, listen: false).user.lastName}"),
        ElevatedButton(
          onPressed: () {
            Provider.of<MutableValues>(context, listen: false).signOut();
          },
          child: const Text("Sign Out"),
        )
      ],
    );
  }
}
