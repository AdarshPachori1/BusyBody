import 'package:adarshpachori/models/mutable_values.dart';
import 'package:adarshpachori/screens/fitness_page.dart';
import 'package:adarshpachori/screens/meals_page.dart';
import 'package:adarshpachori/screens/onboarding/intro_screen.dart';
import 'package:adarshpachori/screens/onboarding/onboarding_one.dart';
import 'package:adarshpachori/screens/profile_page.dart';
import 'package:adarshpachori/screens/sleep_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int bottomNavigationCurrIndex = 1;
  Widget _buildBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return MealsScreen();
      case 1:
        return FitnessScreen();
      case 2:
        return SleepScreen();
      default:
        return ProfileScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MutableValues(),
      child: MaterialApp(
        home: Consumer<MutableValues>(builder: (context, mutableValues, child) {
          return !mutableValues.loggedIn
              ? (!mutableValues.signedUp
                  ? const IntroScreen()
                  : const OnboardingPageOne())
              : Scaffold(
                  appBar: AppBar(
                    title: const Text("Busy Body"),
                  ),
                  body: Center(
                    child: _buildBody(bottomNavigationCurrIndex),
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: bottomNavigationCurrIndex,
                    onTap: (int indexIconSelected) {
                      setState(() {
                        bottomNavigationCurrIndex = indexIconSelected;
                      });
                    },
                    selectedItemColor: Colors.grey,
                    unselectedItemColor: Colors.grey,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.restaurant,
                        ),
                        label: "Meals",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.fitness_center),
                        label: "Fitness",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.night_shelter),
                        label: "Sleep",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: "Profile",
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
