import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  User _user;
  Status _status = Status.Uninitialized;

  Status get status => _status;
  User get user => _user;

  Future<void> signOut() async {
    await _auth.signOut();
    _status = Status.Unauthenticated;
    _user = null;
    notifyListeners();
  }

  Future<String> signIn() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    final UserCredential authResult = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);

      // Add the following lines after getting the user
      // Checking if email and name is null
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      _user = user;
      _status = Status.Authenticated;
      notifyListeners();

      return '$user';
    }

    return null;
  }

  Future<User> getCurrentUser() async {
    print(_status);
    if (_status == Status.Uninitialized) {
      _auth.authStateChanges()
          .listen((User user) {
        _user = user;
        print(user);
        return user;
      });
    } else if (_status == Status.Authenticated) {
      _user = _auth.currentUser;
      return _user;
    } else {
      return null;
    }
  }

}
