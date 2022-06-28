import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/firebase_exceptions.dart';

import '../constants/bottom_bar_text.dart';
import '../utilities/dialogs/error_dialog.dart';

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
                await AuthService.firebase().logIn(
                  email: email,
                  password: pass,
                );
                final user = AuthService.firebase().currentUser;
                if (!mounted) {
                  //kuch error aarha tha toh to solve that google it
                  //we cant use yeh Navigator.of(context)
                  // on async functions toh we have to check yeh conditon
                  return;
                }
                if (user?.isEmailVerified ?? false) {
                  //user email is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  ); //go to main notes page
                } else {
                  //user email is not verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  ); //go to email verify wala page
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context: context,
                  text: "User not Found",
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context: context,
                  text: "wrong-password",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context: context,
                  text: "Authentication Error",
                );
              } catch (e) {
                await showErrorDialog(
                  context: context,
                  text: e.toString(),
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text("Not Registered?\nRegister Here "))
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        elevation: 1,
        child: Text(
          bottomBarText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.pink,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
