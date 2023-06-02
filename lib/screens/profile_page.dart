import 'package:adarshpachori/models/mutable_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int homeSelectedState = 3;
  int workSelectedState = 4;
  int selectedHeight = 0;
  int selectedGender = 0;
  String gender = "Female";
  String height = "4' 1";
  double activityLevel = 1; //1<=activityLevel<=5
  String homeState = "AL";
  String workState = "AL";

  final TextEditingController firstNameInputController =
      TextEditingController();
  final TextEditingController lastNameInputController = TextEditingController();
  final TextEditingController weightInputController = TextEditingController();
  final TextEditingController heightInputController = TextEditingController();
  final TextEditingController birthDateInputController =
      TextEditingController();
  final TextEditingController hoursOfSleepInputController =
      TextEditingController();
  final TextEditingController homeAddressInputController =
      TextEditingController();
  final TextEditingController homeCityInputController = TextEditingController();
  final TextEditingController homeZipcodeInputController =
      TextEditingController();
  final TextEditingController workAddressInputController =
      TextEditingController();
  final TextEditingController workCityInputController = TextEditingController();
  final TextEditingController workZipcodeInputController =
      TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  final double kItemExtent = 32.0;
  final List<String> stateNames = <String>[
    'AL',
    'AK',
    'AZ',
    'AR',
    'CA',
    'CO',
    'CT',
    'DE',
    'FL',
    'GA',
    'HI',
    'ID',
    'IL',
    'IN',
    'IA',
    'KS',
    'KY',
    'LA',
    'ME',
    'MD',
    'MA',
    'MI',
    'MN',
    'MS',
    'MO',
    'MT',
    'NE',
    'NV',
    'NH',
    'NJ',
    'NM',
    'NY',
    'NC',
    'ND',
    'OH',
    'OK',
    'OR',
    'PA',
    'RI',
    'SC',
    'SD',
    'TN',
    'TX',
    'UT',
    'VT',
    'VA',
    'WA',
    'WV',
    'WI',
    'WY'
  ];
  final List<String> genderNames = <String>[
    "Female",
    "Male",
    "Nonbinary",
    "Other",
    "Prefer not to say",
  ];
  final List<String> heightNames = <String>[
    "4' 1\"",
    "4' 2\"",
    "4' 3\"",
    "4' 4\"",
    "4' 5\"",
    "4' 6\"",
    "4' 7\"",
    "4' 8\"",
    "4' 9\"",
    "4' 10\"",
    "4' 11\"",
    "5' 0\"",
    "5' 1\"",
    "5' 2\"",
    "5' 3\"",
    "5' 4\"",
    "5' 5\"",
    "5' 6\"",
    "5' 7\"",
    "5' 8\"",
    "5' 9\"",
    "5' 10\"",
    "5' 11\"",
    "6' 0\"",
    "6' 1\"",
    "6' 2\"",
    "6' 3\"",
    "6' 4\"",
    "6' 5\"",
    "6' 6\"",
    "6' 7\"",
    "6' 8\"",
    "6' 9\"",
    "6' 10\"",
    "6' 11\"",
    "7' 0\"",
  ];
  Future<void> getCurrentUserUUID() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

    if (user != null) {
      final String userUUID = user.uid;


      final DocumentSnapshot userSnapshot =
          await usersCollection.doc(userUUID).get();

      final userData = userSnapshot.data();
      if (userData != null) {
        final Map<String, dynamic> userDataMap = userData as Map<String, dynamic>;
        final String firstName = userDataMap['firstName'];
        firstNameInputController.text = firstName;
        final String lastName = userDataMap['lastName'];
        lastNameInputController.text = lastName;
        weightInputController.text = userDataMap['weight'];
        hoursOfSleepInputController.text = userDataMap['hoursOfSleep'];
        homeAddressInputController.text = userDataMap['homeAddress'];
        homeCityInputController.text = userDataMap['homeCity'];
        homeZipcodeInputController.text = userDataMap['homeZipcode'];
        workAddressInputController.text = userDataMap['workAddress'];
        workCityInputController.text = userDataMap['workCity'];
        workZipcodeInputController.text = userDataMap['workZipcode'];
        selectedHeight = heightNames.indexOf(userDataMap['height']);
        selectedGender = genderNames.indexOf(userDataMap['gender']);
        homeSelectedState = stateNames.indexOf(userDataMap['homeState']);
        workSelectedState = stateNames.indexOf(userDataMap['workState']);
        // scrollController.jumpToItem(selectedHeight);
      }
      // Use currentUserUUID as needed
    }
  }

  void updateProfile() async {
    if (firstNameInputController.text.isNotEmpty) {
      final String newFirstName = firstNameInputController.text;
      final String newLastName = lastNameInputController.text;
      final String newWeight = weightInputController.text;
      final String newHoursSleep = hoursOfSleepInputController.text;
      final String newHomeAddress = homeAddressInputController.text;
      final String newHomeCity = homeCityInputController.text;
      final String newHomeZipcode = homeZipcodeInputController.text;
      final String newWorkAddress = workAddressInputController.text;
      final String newWorkCity = workCityInputController.text;
      final String newWorkZipcode = workZipcodeInputController.text;

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      if (user != null) {
        final String userUUID = user.uid;

        await usersCollection.doc(userUUID).update({
          'firstName': newFirstName,
          'lastName': newLastName,
          'weight': newWeight,
          'hoursOfSleep': newHoursSleep,
          'homeAddress': newHomeAddress,
          'homeCity': newHomeCity,
          'homeZipcode': newHomeZipcode,
          'workAddress': newWorkAddress,
          'workCity': newWorkCity,
          'workZipcode': newWorkZipcode,
          'height': height,
        });
      }
    }
  }

  late FixedExtentScrollController scrollController;
  late FixedExtentScrollController scrollController2;
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              // color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  void initState() {
    Firebase.initializeApp();
    getCurrentUserUUID();
    super.initState();
    scrollController = FixedExtentScrollController(initialItem: selectedHeight);
    scrollController2 = FixedExtentScrollController(initialItem: homeSelectedState);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    
    
    return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
      children: [
        const Text("Profile Page"),
        ElevatedButton(
          onPressed: () {
            Provider.of<MutableValues>(context, listen: false).signOut();
          },
          child: const Text("Sign Out"),
        ),
        Row(
            children: <Widget> [const Text("First Name:  ", style: TextStyle(
    fontSize: 24.0, // set font size to 24
  ),),
              Expanded(
                child: TextField(
                  controller: firstNameInputController
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                  },),
            ],
          ), 
          Row(
            children: <Widget> [const Text("Last Name:  ", style: TextStyle(
    fontSize: 24.0, // set font size to 24
  ),),
              Expanded(
                child: TextField(
                  controller: lastNameInputController
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                  },),
            ],
          ),
          SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('Gender: ',style: TextStyle(fontSize: 22.0)),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      // Display a CupertinoPicker with list of fruits.
                                      onPressed: () => _showDialog(
                                        CupertinoPicker(
                                          magnification: 1.22,
                                          squeeze: 1.2,
                                          useMagnifier: true,
                                          itemExtent: kItemExtent,
                                          // This is called when selected item is changed.
                                          onSelectedItemChanged:
                                              (int selectedItem) {
                                            setState(() {
                                              selectedGender = selectedItem;
                                              gender =
                                                  genderNames[selectedGender];
                                            });
                                          },
                                          children: List<Widget>.generate(
                                              genderNames.length, (int index) {
                                            return Center(
                                              child: Text(
                                                genderNames[index],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      // This displays the selected fruit name.
                                      child: Text(
                                        genderNames[selectedGender],
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
          SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text("Height:  ", style: TextStyle(fontSize: 24.0)), // set font size to 24),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      // Display a CupertinoPicker with list of fruits.
                                      onPressed: () => _showDialog(
                                        CupertinoPicker(
                                          magnification: 1.22,
                                          squeeze: 1.2,
                                          useMagnifier: true,
                                          itemExtent: kItemExtent,
                                          // This is called when selected item is changed.
                                          onSelectedItemChanged:
                                              (int selectedItem) {
                                            setState(() {
                                              selectedHeight = selectedItem;
                                              height =
                                                  heightNames[selectedHeight];
                                            });
                                          },
                                          children: List<Widget>.generate(
                                              heightNames.length, (int index) {
                                            return Center(
                                              child: Text(
                                                heightNames[index],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      // This displays the selected fruit name.
                                      child: Text(
                                        heightNames[selectedHeight],
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),  
                SizedBox(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              "Weight",
                              style: TextStyle(fontSize: 22.0),
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: TextField(
                                controller: weightInputController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              "How many hours of sleep\n would you like to get?",
                              style: TextStyle(fontSize: 22.0),
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: TextField(
                                controller: hoursOfSleepInputController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
            children: <Widget> [const Text("Home Address:  ", style: TextStyle(
    fontSize: 24.0, // set font size to 24
  ),),
              Expanded(
                child: TextField(
                  controller: homeAddressInputController
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // if (lastNameInputController.text.isNotEmpty) {
                    //   final String newHomeAddress = homeAddressInputController.text;

                    //   final FirebaseAuth auth = FirebaseAuth.instance;
                    //   final User? user = auth.currentUser;
                    //   final CollectionReference usersCollection =
                    //       FirebaseFirestore.instance.collection('users');

                    //   if (user != null) {
                    //     final String userUUID = user.uid;

                    //     await usersCollection.doc(userUUID).update({
                    //       'homeAddress': newHomeAddress,
                    //     });
                    //   }
                    // }
                  },),
            ],
          ),
          Row(
            children: <Widget> [const Text("Home City:  ", style: TextStyle(
    fontSize: 24.0, // set font size to 24
  ),),
              Expanded(
                child: TextField(
                  controller: homeCityInputController
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // if (lastNameInputController.text.isNotEmpty) {
                    //   final String newHomeCity = homeCityInputController.text;

                    //   final FirebaseAuth auth = FirebaseAuth.instance;
                    //   final User? user = auth.currentUser;
                    //   final CollectionReference usersCollection =
                    //       FirebaseFirestore.instance.collection('users');

                    //   if (user != null) {
                    //     final String userUUID = user.uid;

                    //     await usersCollection.doc(userUUID).update({
                    //       'homeCity': newHomeCity,
                    //     });
                    //   }
                    // }
                  },),
            ],
          ),
          SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('Home State: '),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      // Display a CupertinoPicker with list of fruits.
                                      onPressed: () => _showDialog(
                                        CupertinoPicker(
                                          magnification: 1.22,
                                          squeeze: 1.2,
                                          useMagnifier: true,
                                          itemExtent: kItemExtent,
                                          // This is called when selected item is changed.
                                          onSelectedItemChanged:
                                              (int selectedItem) {
                                            setState(() {
                                              homeSelectedState = selectedItem;
                                              homeState =
                                                  stateNames[homeSelectedState];
                                            });
                                          },
                                          children: List<Widget>.generate(
                                              stateNames.length, (int index) {
                                            return Center(
                                              child: Text(
                                                stateNames[index],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      // This displays the selected fruit name.
                                      child: Text(
                                        stateNames[homeSelectedState],
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
          SizedBox(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              "Home Zipcode",
                              style: TextStyle(fontSize: 22.0),
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: TextField(
                                controller: homeZipcodeInputController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
            children: <Widget> [const Text("Work Address:  ", style: TextStyle(
    fontSize: 24.0, // set font size to 24
  ),),
              Expanded(
                child: TextField(
                  controller: workAddressInputController
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // if (lastNameInputController.text.isNotEmpty) {
                    //   final String newWorkAddress = workAddressInputController.text;

                    //   final FirebaseAuth auth = FirebaseAuth.instance;
                    //   final User? user = auth.currentUser;
                    //   final CollectionReference usersCollection =
                    //       FirebaseFirestore.instance.collection('users');

                    //   if (user != null) {
                    //     final String userUUID = user.uid;

                    //     await usersCollection.doc(userUUID).update({
                    //       'workAddress': newWorkAddress,
                    //     });
                    //   }
                    // }
                  },),
            ],
          ),
          Row(
            children: <Widget> [const Text("Work City:  ", style: TextStyle(
    fontSize: 24.0, // set font size to 24
  ),),
              Expanded(
                child: TextField(
                  controller: workCityInputController
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    // if (lastNameInputController.text.isNotEmpty) {
                    //   final String newWorkCity = workCityInputController.text;

                    //   final FirebaseAuth auth = FirebaseAuth.instance;
                    //   final User? user = auth.currentUser;
                    //   final CollectionReference usersCollection =
                    //       FirebaseFirestore.instance.collection('users');

                    //   if (user != null) {
                    //     final String userUUID = user.uid;

                    //     await usersCollection.doc(userUUID).update({
                    //       'workCity': newWorkCity,
                    //     });
                    //   }
                    // }
                  },),
            ],
          ),
          SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('Work State: '),
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      // Display a CupertinoPicker with list of fruits.
                                      onPressed: () => _showDialog(
                                        CupertinoPicker(
                                          magnification: 1.22,
                                          squeeze: 1.2,
                                          useMagnifier: true,
                                          itemExtent: kItemExtent,
                                          // This is called when selected item is changed.
                                          onSelectedItemChanged:
                                              (int selectedItem) {
                                            setState(() {
                                              workSelectedState = selectedItem;
                                              workState =
                                                  stateNames[workSelectedState];
                                            });
                                          },
                                          children: List<Widget>.generate(
                                              stateNames.length, (int index) {
                                            return Center(
                                              child: Text(
                                                stateNames[index],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      // This displays the selected fruit name.
                                      child: Text(
                                        stateNames[workSelectedState],
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
          SizedBox(
                      height: 90,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              "Work Zipcode",
                              style: TextStyle(fontSize: 22.0),
                            ),
                            const SizedBox(width: 8.0),
                            Flexible(
                              child: TextField(
                                controller: workZipcodeInputController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
          onPressed: () {
            updateProfile();
          },
          child: const Text("Save Changes"),
        )
          
      ],
    )));
  }
}


