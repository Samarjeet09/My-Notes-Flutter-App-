import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/auth/firebase_exceptions.dart';

import '../constants/bottom_bar_text.dart';
import '../utilities/dialogs/error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(children: [
        const Text("Check your email address for the Email verification"),
        const Text(
            "If you haven't recieved it yet, Please press the button below"),
        TextButton(
          onPressed: () async {
            try {
              await AuthService.firebase().sendEmailVerification();
            } on UserNotLoggedInAuthException {
              showErrorDialog(context: context, text: "User is Not Logged in");
            }
          },
          child: const Text("Send Email verification"),
        ),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            if (!mounted) return;
            Navigator.of(context)
                .pushNamedAndRemoveUntil(registerRoute, (route) => false);
          },
          child: const Text("Restart"),
        ),
      ]),
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
