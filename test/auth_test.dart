import 'package:flutter_test/flutter_test.dart';
import 'package:notesapp/services/auth/auth_provider.dart';
import 'package:notesapp/services/auth/auth_user.dart';
import 'package:notesapp/services/auth/firebase_exceptions.dart';

void main() {
  group(
    'Mock Authentication',
    () {
      final provider = MockAuthProvider();

      test(
        "Shouldn't be initialized to begin with",
        () {
          expect(provider.isInitialized, false);
        },
      );

      test(
        "Not log out if not initialized",
        () {
          expect(
            provider.logOut(),
            //we expect an Exception
            throwsA(const TypeMatcher<NotInitializedException>()),
          );
        },
      );

      test(
        "Should be able to initialize",
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
      );

      test(
        "User Shloud be null after initialization",
        () {
          expect(provider._user, null);
        },
      );

      test(
        "Should be able to initialize in less the 2 seconds",
        () async {
          await provider.initialize();
          expect(provider.isInitialized, true);
        },
        timeout: const Timeout(Duration(seconds: 2)),
      );

      test(
        "Create User should delgate to login",
        () async {
          final badEmailUser = provider.createUser(
            email: 'foo@bar.com',
            password: "password",
          );
          expect(
            badEmailUser,
            throwsA(const TypeMatcher<InvalidEmailAuthException>()),
          );
          final badPasswordUser = provider.createUser(
            email: "email",
            password: "foobar",
          );
          expect(
              badPasswordUser,
              throwsA(
                const TypeMatcher<WrongPasswordAuthException>(),
              ));
          final user = await provider.createUser(
            email: "email",
            password: "password",
          );
          expect(provider.currentUser, user);
          expect(user.isEmailVerified, false);
        },
      );
      test(
        'A Logged in user should be able to verify email',
        () async {
          await provider.sendEmailVerification();
          final user = provider.currentUser;
          expect(user, isNotNull);
          expect(user?.isEmailVerified, true);
        },
      );
      test(
        "Loggin in and logging out",
        () async {
          await provider.logOut();
          await provider.logIn(email: "email", password: "password");
          final user = provider.currentUser;
          expect(user, isNotNull);
        },
      );
    },
  );
}

class NotInitializedException {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!_isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw InvalidEmailAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user = AuthUser(email: 'email', isEmailVerified: false, id: 'id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!_isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!_isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(email: 'email', isEmailVerified: true, id: 'id');
    _user = newUser;
  }
}
