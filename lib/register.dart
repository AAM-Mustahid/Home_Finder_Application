import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:home_finder_app/UserProvider.dart';
import 'package:home_finder_app/constants.dart';
import 'package:home_finder_app/layout.dart';
import 'package:home_finder_app/login.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _name = '', _email = '', _password = '';

  Future<UserCredential?> _signInWithGoogle() async {
    await _googleSignIn.signOut(); // Add this line
    await _auth.signOut();
    Provider.of<UserProvider>(context, listen: false).user = null;

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print('userCredential.user ${userCredential.user}');

      if (userCredential.user != null) {
        if (userCredential.user!.metadata.creationTime !=
            userCredential.user!.metadata.lastSignInTime) {
          print("making call");

          await _saveUserToDatabase(userCredential.user!);
        }
      }

      if (userCredential.user != null) {
        Fluttertoast.showToast(
            msg: "Continued with ${userCredential.user!.email}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 12.0);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyLayout()),
        );
      }

      print('my userCredential ${userCredential}');

      return userCredential;
    }
    return null;
  }

  Future<UserCredential?> _signUpWithEmailPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: _email, password: _password);
        await userCredential.user!.updateDisplayName(_name);

        await _saveUserToDatabase(userCredential.user!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyLayout()),
        );

        return userCredential;
      } catch (e) {
        // Handle error
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
    return null;
  }

  Future<void> _saveUserToDatabase(User user) async {
    try {
      var dio = Dio();
      await dio.post(
        '${Constants.server}/users/create', // Replace with your database URL
        data: {
          'name': user.displayName ?? _name,
          'email': user.email,
          'photoURL': user.photoURL ?? 'No Photo',
          'uid': user.uid,
        },
      );
    } catch (e) {
      print('Failed to make POST request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(height: 50.0),
            Center(
              child: Image.asset('assets/images/logo.png',
                  height: 100.0), // Replace with your logo asset
            ),
            SizedBox(height: 50.0),
            Text(
              'Register',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              onSaved: (value) => _name = value!,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter email' : null,
              onSaved: (value) => _email = value!,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter password' : null,
              onSaved: (value) => _password = value!,
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Sign Up', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                _signUpWithEmailPassword();
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              icon: Image.asset('assets/images/google.png',
                  height: 20.0), // Replace with your Google logo asset
              label: Text('Continue with Google'),
              onPressed: () async {
                try {
                  UserCredential? user = await _signInWithGoogle();
                  print("continue with google");

                  print("my userinfo ${user}");
                } catch (e) {
                  print("Error signing in with Google: $e");
                }
              },
            ),
            ElevatedButton(
              child: const Text('Continue as a Guest'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyLayout()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
