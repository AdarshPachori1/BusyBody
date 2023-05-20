import 'package:adarshpachori/models/mutable_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String emailInput = "";
  String passwordInput = "";
  final auth = FirebaseAuth.instance;
  String errorMessage = "";
  bool displayErrorMessage = false;
  bool _isLoading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUser(
    String uuid,
  ) {
    CollectionReference users = firestore.collection('users');
    return users
        .doc(uuid)
        .set({
          'uuid': uuid,
        })
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      emailInput = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      passwordInput = value;
                    });
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await auth
                          .createUserWithEmailAndPassword(
                              email: emailInput, password: passwordInput)
                          .then((userObj) {
                        print(userObj.user!.uid);
                        print("Success");
                        Provider.of<MutableValues>(context, listen: false)
                            .signUp(userObj.user!.uid);
                        addUser(userObj.user!.uid);
                        Navigator.pop(context);
                      });

                      // User registration successful
                    } on FirebaseAuthException catch (e) {
                      String msgToPrint = "";
                      if (e.code == 'weak-password') {
                        msgToPrint = 'The password provided is too weak.';
                      } else if (e.code == 'email-already-in-use') {
                        msgToPrint =
                            'The account already exists for that email.';
                      }
                      print(msgToPrint);
                      setState(() {
                        displayErrorMessage = true;
                        errorMessage = msgToPrint;
                      });
                    } catch (e) {
                      print(e.toString());
                      setState(() {
                        displayErrorMessage = true;
                        errorMessage = e.toString();
                      });
                    } finally {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: const Text("Sign Up"),
                ),
                displayErrorMessage ? Text(errorMessage) : Container()
              ],
            ),
    );
  }
}
