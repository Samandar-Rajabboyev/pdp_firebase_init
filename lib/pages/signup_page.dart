import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/services/auth_service.dart';

import '../services/prefs_service.dart';
import '../services/utlis_services.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'signup_page';
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isLoading = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _doSingUp() {
    String email = _emailController.text.toString().trim();
    String fullName = _fullNameController.text.toString().trim();
    String password = _passwordController.text.toString().trim();
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, fullName, email, password).then((user) {
      _getFirebaseUser(user);
    });
  }

  _getFirebaseUser(User? user) async {
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      await Prefs.saveUserId(user.uid).then((value) {
        Navigator.pushReplacementNamed(context, HomePage.id);
      });
    } else {
      Utils.fireToast("Check your informations");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(hintText: 'Fullname'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: _doSingUp,
                    color: Colors.deepOrange,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, SignInPage.id);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text("Already have an account?", style: TextStyle(color: Colors.black)),
                        SizedBox(width: 10),
                        Text("Sign In", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
