import 'dart:convert';
import 'package:adarshpachori/models/mutable_values.dart';
import 'package:adarshpachori/screens/fitness_page.dart';
import 'package:adarshpachori/screens/meals_page.dart';
import 'package:adarshpachori/screens/onboarding/intro_screen.dart';
import 'package:adarshpachori/screens/onboarding/onboarding_one.dart';
import 'package:adarshpachori/screens/profile_page.dart';
import 'package:adarshpachori/screens/sleep_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;


int sleepTime = 0;
int commuteMins = 0;
String startAddress = "";

Future<void> getCurrentUserUUID() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;


  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  if (user != null) {
    final String userUUID = user.uid;
    print(userUUID);

    final DocumentSnapshot userSnapshot =
        await usersCollection.doc(userUUID).get();

    final userData = userSnapshot.data();
    if (userData != null) {
      print("got userdata");
      final Map<String, dynamic> userDataMap = userData as Map<String, dynamic>;
      final int hoursOfSleep = int.parse(userDataMap['hoursOfSleep']);
      final String homeAddress = userDataMap['homeAddress'] + userDataMap['homeCity'] + userDataMap['homeState'] + userDataMap['homeZipcode'];
      final String workAddress = userDataMap['workAddress'] + userDataMap['workCity'] + userDataMap['workState'] + userDataMap['workZipcode'];
      print("got values");
      if (hoursOfSleep != null) {
        sleepTime = hoursOfSleep;
      }
      String Url = 'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${homeAddress}&destinations=${workAddress}&key=AIzaSyAf_JKdwcVADXSC6XVZKi8C3HYgn7iHjWo';
      try {
        print("got to http");
        var response = await http.get(
          Uri.parse(Url),);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          commuteMins = int.parse(data["rows"][0]["elements"][0]["duration"]["text"].split(' ')[0]);
      }}
      catch (e) {
        print(e);
      }
    }
    // Use currentUserUUID as needed
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // getDistance();
  await getCurrentUserUUID();
  print(sleepTime);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  tz.initializeTimeZones();

Future<void> scheduleNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your_channel_id', 'your_channel_name', 'your_channel_description',
          importance: Importance.max, priority: Priority.high, ticker: 'ticker');
  const IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  // final tz.TZDateTime scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
  tz.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation('your_timezone'));

  var currentTime = tz.TZDateTime.now(tz.local);
  var notificationTime = tz.TZDateTime(
    tz.local,
    currentTime.year,
    currentTime.month,
    currentTime.day,
    9,
    0,
  ).subtract(Duration(hours: sleepTime, minutes: commuteMins));

  if (notificationTime.isBefore(currentTime)) {
    notificationTime = notificationTime.add(Duration(days: 1));
  }
  print(notificationTime);
  
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0, // Notification ID
    'Bedtime Reminder', // Notification title
    'Your bedtime is set for now', // Notification body
    notificationTime, // Scheduled date and time
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
// DateTime now = DateTime.now();
// DateTime scheduledTime = DateTime(now.year,now.month, now.day, 12, 55, 0); // Example: schedule after 1 hour from now
await scheduleNotification();
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
