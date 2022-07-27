import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/services/prefs_service.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<User?> signInUser(BuildContext context, String email, String password) async {
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = _auth.currentUser;
      debugPrint(user.toString());
      return user;
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  static Future<User?> signUpUser(BuildContext context, String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final User? user = authResult.user;
      debugPrint(user.toString());
      return user;
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }
}
