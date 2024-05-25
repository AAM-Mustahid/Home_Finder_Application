import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_finder_app/decor.dart';
import 'package:home_finder_app/designer.dart';
import 'package:home_finder_app/home.dart';
import 'package:home_finder_app/login.dart';
import 'package:home_finder_app/shifting.dart';
import 'package:home_finder_app/splash.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:home_finder_app/UserProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = _auth.currentUser;

  if (currentUser == null) {
    // Handle the case where currentUser is null
    print('No user is currently signed in.');
  } else {
    // Use currentUser
    print('User is signed in as ${currentUser.uid}');
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        UserProvider userProvider = UserProvider();
        userProvider.user = currentUser;
        return userProvider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/listing': (context) => HomePage(),
          '/shifting': (context) => ShiftingPage(),
          '/decor': (context) => DecorPage(),
          '/interior': (context) => DesignerPage(),
        },
      ),
    ),
  );
}
