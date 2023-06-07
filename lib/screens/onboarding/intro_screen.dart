import 'package:adarshpachori/models/mutable_values.dart';
import 'package:adarshpachori/screens/onboarding/login_screen.dart';
import 'package:adarshpachori/screens/onboarding/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              child: const Text("Sign Up"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LogInScreen(),
                  ),
                );
              },
              child: const Text("Log In"),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: GestureDetector(
                child: const Text("Log In as Guest"),
                onTap: () {
                  context.read<MutableValues>().signIn("Guest");
                  //Provider.of<MutableValues>(context, listen: false).signIn();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

