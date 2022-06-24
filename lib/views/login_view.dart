import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text("Login page")),
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
              try {
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(email: email, password: pass);
                print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  print("user-not-found");
                } else if (e.code == 'wrong-password') {
                  print("wrong-password");
                } else {
                  print("SOMETHING ELSE");
                  print(e.code);
                }
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: const Text("Not Registered?\nRegister Here "))
        ],
      ),
    );
  }
}
