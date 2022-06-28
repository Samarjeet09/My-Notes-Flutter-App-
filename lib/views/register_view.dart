import 'package:flutter/material.dart';
import 'package:notesapp/constants/bottom_bar_text.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/firebase_exceptions.dart';
import '../utilities/dialogs/error_dialog.dart';

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
                await AuthService.firebase().createUser(
                  email: email,
                  password: pass,
                );
                await AuthService.firebase().sendEmailVerification();
                if (!mounted) return;
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context: context,
                  text: "weak password",
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context: context,
                  text: "invalid email",
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context: context,
                  text: "Email already in use",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context: context,
                  text: "Registeration Error",
                );
              } catch (e) {
                await showErrorDialog(
                  context: context,
                  text: e.toString(),
                );
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
