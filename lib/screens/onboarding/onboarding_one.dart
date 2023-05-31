import 'package:adarshpachori/models/mutable_values.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OnboardingPageOne extends StatefulWidget {
  const OnboardingPageOne({super.key});

  @override
  State<OnboardingPageOne> createState() => _OnboardingPageOneState();
}

class _OnboardingPageOneState extends State<OnboardingPageOne> {
  String gender = "Female";
  String height = "4' 1";
  double activityLevel = 1; //1<=activityLevel<=5
  String homeState = "AL";
  String workState = "AL";

  final TextEditingController firstNameInputController =
      TextEditingController();
  final TextEditingController lastNameInputController = TextEditingController();
  final TextEditingController weightInputController = TextEditingController();
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

  int homeSelectedState = 0;
  int workSelectedState = 0;
  int selectedHeight = 0;
  int selectedGender = 0;

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

  Future<void> addUser(String uuid) async {
    CollectionReference users = firestore.collection('users');
    DocumentReference<Object?> docRef = users.doc(uuid);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    await docRef
        .set({
          ...data,
          'firstName': firstNameInputController.text,
          'lastName': lastNameInputController.text,
          'weight': weightInputController.text,
          'birthDate': birthDateInputController.text,
          'gender': gender,
          'height': height,
          'activityLevel': activityLevel,
          'hoursOfSleep': hoursOfSleepInputController.text,
          'homeAddress': homeAddressInputController.text,
          'homeCity': homeCityInputController.text,
          'homeState': homeState,
          'homeZipcode': homeZipcodeInputController.text,
          'workAddress': workAddressInputController.text,
          'workCity': workCityInputController.text,
          'workState': workState,
          'workZipcode': workZipcodeInputController.text
        })
        .then((value) => print("User modified"))
        .catchError((error) => print("Failed to modify user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          // Sets the content of the Application
                          // child: CupertinoPickerApp(),
                          children: [
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    const Text(
                                      "First Name",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        controller: firstNameInputController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  ])),
                            ),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    const Text(
                                      "Last Name",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        controller: lastNameInputController,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  ])),
                            ),
                            SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('Height: '),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
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
                                    )
                                  ])),
                            ),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    const Text(
                                      "Enter Birth Date:",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        controller: birthDateInputController,
                                        readOnly: true,
                                        onTap: () async {
                                          await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime.now())
                                              .then((pickedDate) {
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate!);
                                            setState(() {
                                              birthDateInputController.text =
                                                  formattedDate; //set output date to TextField value.
                                            });
                                          });
                                        },
                                      ),
                                    )
                                  ])),
                            ),
                            SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('Gender: '),
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
                              height: 150,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(children: <Widget>[
                                    const Text(
                                      "Activity Level:",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: CupertinoSlider(
                                        key: const Key('slider'),
                                        value: activityLevel,
                                        divisions: 4,
                                        max: 100,
                                        activeColor:
                                            CupertinoColors.systemPurple,
                                        thumbColor:
                                            CupertinoColors.systemPurple,
                                        onChanged: (double value) {
                                          setState(() {
                                            activityLevel = value;
                                          });
                                        },
                                      ),
                                    )
                                  ])),
                            ),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    const Text(
                                      "How many hours of sleep\n would you like to get?",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        controller: hoursOfSleepInputController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  ])),
                            ),
                            const SizedBox(
                                height: 20,
                                child: Text(
                                  "Home Address:",
                                  style: TextStyle(fontSize: 20.0),
                                )),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "Address",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          controller:
                                              homeAddressInputController,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "City",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          controller: homeCityInputController,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('State: '),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "Zip Code",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          controller:
                                              homeZipcodeInputController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(
                                height: 20,
                                child: Text(
                                  "Work Address:",
                                  style: TextStyle(fontSize: 20.0),
                                )),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "Address",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          controller:
                                              workAddressInputController,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 90,
                              child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "City",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          controller: workCityInputController,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 90,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    const Text('State: '),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Text(
                                        "Zip Code",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          controller:
                                              workZipcodeInputController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await addUser(
                                    context.read<MutableValues>().uuid,
                                  ).then(
                                    (usr) {
                                      context
                                          .read<MutableValues>()
                                          .completedSignUp();
                                    },
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                                child: const Text("Update Database"))
                          ])))),
    );
  }
}
