import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:notesapp/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;
  // we need the flow of information btw text fields and the button
  // thus we use TextEditingController
  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  } //humnei ek tarhan sei constuctor ko overlaod kiya batya ki yeh vars ko bana dena

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  } //basicalyy like destructor ko overlaod kar diya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: "Enter your Email"),
            // making email field better
            autocorrect: false,
            enableSuggestions: false,
            // we will tell ki email wala keyboard chaiye
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _pass,
            decoration: const InputDecoration(hintText: "Enter your Password"),
            // now to make it a better password field
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final pass = _pass.text;
              // initialzing the firebase--> ek package aur dala  'firebase_options.dart';
              try {
                final userCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: pass);
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == "weak-password") {
                  devtools.log("weak password");
                } else if (e.code == "email-already-in-use") {
                  devtools.log("Email already in use");
                } else if (e.code == 'invalid-email') {
                  devtools.log("invalid email");
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false),
              child: const Text('Login Instead'))
        ],
      ),
    );
  }
}
