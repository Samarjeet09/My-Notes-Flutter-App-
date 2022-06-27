import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/views/login_view.dart';
import 'package:notesapp/views/notes/new_note_view.dart';
import 'package:notesapp/views/notes/notes_view.dart';
import 'package:notesapp/views/register_view.dart';
import 'package:notesapp/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // as above line sei clear hai we make sure its done to initialize the firebase
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context)=> const NewNotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //yahan pei we  added a future builder to make sure
      // that firbase app is initialzed first(as it is a futre) and then the colloum is rendered
      // toh humnei vo sara code uskei return mei likh diya
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        //yahan pei loading screen
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                devtools.log("Email is Verified");
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            //basically agar laod na ho ya time le toh yeh display ho
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
