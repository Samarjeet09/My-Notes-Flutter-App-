import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

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
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
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
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                print("You are a verified");
              } else {
                print("Verfiy first");
              }
              return const Text("Done");
            default:
              //basically agar laod na ho ya time le toh yeh display ho
              return const Text("Loading Please Wait");
          }
        },
      ),
    );
  }
}
