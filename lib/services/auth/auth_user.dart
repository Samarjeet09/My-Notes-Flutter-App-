import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String id;
  const AuthUser(
      {required this.id, required this.email, required this.isEmailVerified});
  // we will use factory constructor jo already exsisting constructor sei
  //lekar new mei kaam karega

  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified,
        id: user.uid,
      );
  //basically humnei firebase user ka copy apnei mei daal liya
}
