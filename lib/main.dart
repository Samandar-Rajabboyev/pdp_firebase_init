import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:herewego/pages/add_post_page.dart';
import 'package:herewego/pages/home_page.dart';
import 'package:herewego/pages/signin_page.dart';
import 'package:herewego/pages/signup_page.dart';
import 'package:herewego/services/prefs_service.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, stream) {
        if (stream.hasData) {
          Prefs.saveUserId(stream.data?.uid ?? '');
          return const HomePage();
        } else {
          Prefs.removeUserId();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _startPage(),
      routes: {
        HomePage.id: (_) => const HomePage(),
        SignInPage.id: (_) => const SignInPage(),
        SignUpPage.id: (_) => const SignUpPage(),
        AddPostPage.id: (_) => const AddPostPage(),
      },
    );
  }
}
