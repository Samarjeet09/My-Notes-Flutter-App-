import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});
  // we will use factory constructor jo already exsisting constructor sei
  //lekar new mei kaam karega

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
  //basically humnei firebase user ka copy apnei mei daal liya
}
