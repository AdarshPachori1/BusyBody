import 'package:adarshpachori/models/mutable_values.dart';
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        firstName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your first name.',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        lastName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your last name.',
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await addUser(context.read<MutableValues>().uuid,
                                firstName, lastName)
                            .then(
                          (usr) {
                            context.read<MutableValues>().completedSignUp();
                          },
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: const Text("Update Database"))
                ],
              ),
      ),
    );
  }
}
