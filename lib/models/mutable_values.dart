import 'package:adarshpachori/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MutableValues extends ChangeNotifier {
  bool _loggedIn = false;
  bool _signingUp = false;
  String _uuid = "";
  User _user = User(
    firstName: "",
    lastName: "",
    gender: "",
    height: "",
    birthDate: "",
    activityLevel: 1,
    desiredDaysPerWeek: 1,
    desiredTimePerWorkout: 1,
    desiredCalories: 1000,
    desiredProtein: 30,
    desiredCarbs: 35,
    desiredFat: 10,
    desiredPriceLevel: 2,
    homeAddress: "",
    homeCity: "",
    homeState: "",
    homeZipcode: "",
    hoursOfSleep: "",
    uuid: "",
    weight: "",
    workAddress: "",
    workCity: "",
    workState: "",
    workZipcode: "",
  );
  bool get loggedIn => _loggedIn;
  bool get signedUp => _signingUp;
  String get uuid => _uuid;
  User get user => _user;

  void signUp(String uuid) {
    _uuid = uuid;
    _signingUp = true;
    notifyListeners();
  }

  void completedSignUp(
      {required String firstName,
      required String lastName,
      required String gender,
      required String height,
      required String birthDate,
      required num activityLevel,
      required String homeAddress,
      required String homeCity,
      required String homeState,
      required String homeZipcode,
      required String hoursOfSleep,
      required String weight,
      required String workAddress,
      required String workCity,
      required String workState,
      required String workZipcode,
      required num desiredDaysPerWeek,
      required num desiredTimePerWorkout,
      required num desiredCalories,
      required num desiredProtein,
      required num desiredCarbs,
      required num desiredFat,
      required num desiredPriceLevel}) {
    _signingUp = false;
    _loggedIn = true;
    _user = User(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        height: height,
        birthDate: birthDate,
        activityLevel: activityLevel,
        homeAddress: homeAddress,
        homeCity: homeCity,
        homeState: homeState,
        homeZipcode: homeZipcode,
        hoursOfSleep: hoursOfSleep,
        uuid: uuid,
        weight: weight,
        workAddress: workAddress,
        workCity: workCity,
        workState: workState,
        workZipcode: workZipcode,
        desiredDaysPerWeek: desiredDaysPerWeek,
        desiredTimePerWorkout: desiredTimePerWorkout,
        desiredCalories: desiredCalories,
        desiredProtein: desiredProtein,
        desiredCarbs: desiredCarbs,
        desiredFat: desiredFat,
        desiredPriceLevel: desiredPriceLevel);
    notifyListeners();
  }

  void signIn(String? uuid) async {
    if (uuid != null) {
      _uuid = uuid;
    }
    await getDocument(_uuid).then((usr) {
      _user = usr;
      _loggedIn = true;
      notifyListeners();
    });
    //fetch info and populate user object
  }

  void signOut() {
    _loggedIn = false;
    notifyListeners();
  }

  Future<User> getDocument(String uuid) async {
    Map<String, dynamic> data = {};
    try {
      // Retrieve a document from a collection
      DocumentSnapshot document =
          await FirebaseFirestore.instance.collection('users').doc(uuid).get();

      if (document.exists) {
        // Document exists, access its data
        data = document.data() as Map<String, dynamic>;
        // Do something with the data
        print('Document data: $data');
      } else {
        // Document doesn't exist
        print('Document does not exist');
      }
    } catch (e) {
      // Handle any errors
      print('Error retrieving document: $e');
    }
    print("activity Level: ${data["activityLevel"]}");
    return User(
        firstName: data["firstName"],
        lastName: data["lastName"],
        gender: data["gender"],
        height: data["height"],
        birthDate: data["birthDate"],
        activityLevel: data["activityLevel"],
        homeAddress: data["homeAddress"],
        homeCity: data["homeCity"],
        homeState: data["homeState"],
        homeZipcode: data["homeZipcode"],
        hoursOfSleep: data["hoursOfSleep"],
        uuid: uuid,
        weight: data["weight"],
        workAddress: data["workAddress"],
        workCity: data["workCity"],
        workState: data["workState"],
        workZipcode: data["workZipcode"],
        desiredDaysPerWeek: data["daysPerWeek"],
        desiredTimePerWorkout: double.parse(data["timePerWorkout"]),
        desiredCalories: double.parse(data["desiredCalories"]),
        desiredProtein: double.parse(data["desiredProtein"]),
        desiredCarbs: double.parse(data["desiredCarbs"]),
        desiredFat: double.parse(data["desiredFat"]),
        desiredPriceLevel: data["priceLevel"]);
  }
}
