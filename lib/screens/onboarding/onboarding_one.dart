import 'package:adarshpachori/models/mutable_values.dart';
import 'package:adarshpachori/widgets/activity_slider.dart';
import 'package:adarshpachori/widgets/custom_cupertino_picker.dart';
import 'package:adarshpachori/widgets/date_picker.dart';
import 'package:adarshpachori/widgets/gender_picker.dart';
import 'package:adarshpachori/widgets/state_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class OnboardingPageOne extends StatefulWidget {
  const OnboardingPageOne({super.key});

  @override
  State<OnboardingPageOne> createState() => _OnboardingPageOneState();
}

class _OnboardingPageOneState extends State<OnboardingPageOne> {
  String firstName = "";
  String lastName = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> addUser(String uuid, String firstName, String lastName) async {
    CollectionReference users = firestore.collection('users');
    DocumentReference<Object?> docRef = users.doc(uuid);
    DocumentSnapshot snapshot = await docRef.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    await docRef
        .set({
          ...data,
          'firstName': firstName,
          'lastName': lastName,
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
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      "First Name",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  ])),
                            ),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      "Last Name",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  ])),
                            ),
                            const SizedBox(
                                height: 90, child: CustomCupertinoPicker()),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      "Weight",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                        ),
                                      ),
                                    )
                                  ])),
                            ),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      "Enter Birth Date:",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: DatePicker(),
                                    )
                                  ])),
                            ),
                            const SizedBox(height: 90, child: GenderPicker()),
                            const SizedBox(
                              height: 150,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      "Activity Level:",
                                      style: TextStyle(fontSize: 22.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: ActivitySlider(),
                                    )
                                  ])),
                            ),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(children: <Widget>[
                                    Text(
                                      "How many hours of sleep\n would you like to get?",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
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
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Address",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "City",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(height: 90, child: StatePicker()),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Zip Code",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
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
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Address",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "City",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            border: UnderlineInputBorder(),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            const SizedBox(height: 90, child: StatePicker()),
                            const SizedBox(
                              height: 90,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Zip Code",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
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
                                          firstName,
                                          lastName)
                                      .then(
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
