import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
        title: const Text("Registeration Page"),
      ),
      body: FutureBuilder(
        //yahan pei we  added a future builder to make sure
        // that firbase app is initialzed first(as it is a futre) and then the colloum is rendered
        // toh humnei vo sara code uskei return mei likh diya
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          //yahan pei loading screen
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration:
                        const InputDecoration(hintText: "Enter your Email"),
                    // making email field better
                    autocorrect: false,
                    enableSuggestions: false,
                    // we will tell ki email wala keyboard chaiye
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _pass,
                    decoration:
                        const InputDecoration(hintText: "Enter your Password"),
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
                        print(userCredential);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "weak-password") {
                          print("weak password");
                        } else if (e.code == "email-already-in-use") {
                          print("Email already in use");
                        } else if (e.code == 'invalid-email') {
                          print("invalid email");
                        }
                      }
                    },
                    child: const Text("Register"),
                  ),
                ],
              );
            default:
              //basically agar laod na ho ya time le toh yeh display ho
              return const Text("Loading Please Wait");
          }
        },
      ),
    );
  }
}
