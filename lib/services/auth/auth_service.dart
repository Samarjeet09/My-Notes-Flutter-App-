import 'package:notesapp/services/auth/firebase_auth_provider.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

// the auth service is an auth provider
// It relays information of the given auth provider
//but can have some more logic
class AuthService implements AuthProvider {
  // it is not hard coded to use FirebaseAuthProvider BUT
  // it actually gonna take a AuthProvider form us and THEN
  // expose the Functionalites of the AuthProvider to the
  // outside world
  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();
}
