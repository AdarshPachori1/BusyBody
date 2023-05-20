import 'package:adarshpachori/models/mutable_values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String emailInput = "";
  String passwordInput = "";
  final auth = FirebaseAuth.instance;
  String errorMessage = "";
  bool displayErrorMessage = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                          .signInWithEmailAndPassword(
                        email: emailInput,
                        password: passwordInput,
                      )
                          .then((UserCredential userCredential) {
                        Provider.of<MutableValues>(context, listen: false)
                            .signIn(userCredential.user!.uid);

                        Navigator.pop(context);
                      });
                    } on FirebaseAuthException catch (e) {
                      String msgToPrint = "";
                      if (e.code == 'user-not-found') {
                        msgToPrint = 'No user found for that email.';
                      } else if (e.code == 'wrong-password') {
                        msgToPrint = 'Wrong password provided for that user.';
                      }
                      setState(() {
                        displayErrorMessage = true;
                        errorMessage = msgToPrint;
                      });
                    } catch (e) {
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
                  child: const Text("Log In"),
                ),
                displayErrorMessage ? Text(errorMessage) : Container()
              ],
            ),
    );
  }
}
