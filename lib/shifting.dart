import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_finder_app/decor.dart';
import 'package:home_finder_app/designer.dart';
import 'package:home_finder_app/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:home_finder_app/login.dart';
import 'constants.dart';

class BulletPoint extends StatelessWidget {
  final String text;

  BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.check, color: Colors.white),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class ShiftingPage extends StatefulWidget {
  @override
  _ShiftingPageState createState() => _ShiftingPageState();
}

class _ShiftingPageState extends State<ShiftingPage> {
  final _formKey = GlobalKey<FormState>();
  String? name, phone, email, dayOfShifting, fromLocation, toLocation;
  void submitForm() async {
    print("Submitting");
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      try {
        final response = await Dio().post(
          '${Constants.server}/shiftings/create',
          data: {
            'name': name,
            'phone': phone,
            'email': email,
            'dayOfShifting': dayOfShifting,
            'from_location': fromLocation,
            'to_location': toLocation,
            'submittedBy': '1',
          },
        );

        print("myresponse: ${response}");

        if (response.statusCode == 200) {
          print("Form submitted successfully");
          Fluttertoast.showToast(
            msg: "Form submitted successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          form.reset();
          FocusScope.of(context).unfocus();
        } else {
          print("Form failed to submit");
          Fluttertoast.showToast(
            msg: "Failed to submit form",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("Failed to submit form: $e");
        Fluttertoast.showToast(
          msg: "Failed to submit form",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  // The image
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                    child: Image.asset(
                      'assets/images/homeshifting.jpg',
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // The text
                  Center(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'House Shifting Service',
                            style: TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                BulletPoint(
                                    'Trusted, Background Checked & Skilled Movers'),
                                BulletPoint(
                                    'Superior Packaging, Loading-unloading & Quality Moving Services'),
                                BulletPoint(
                                    "Bangladesh's Highest-rated & Premium Shifting Service"),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Contact us to ease your shifting process',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Please do not hesitate to reach out to us for a seamless transition during your relocation. To initiate the process, kindly complete the following form.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => name = value,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Phone',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => phone = value,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => email = value,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Day of shifting',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => dayOfShifting = value,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'From location',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => fromLocation = value,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'To location',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => toLocation = value,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: submitForm,
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF3C91E6)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: Colors.white.withOpacity(0.4)),
                        ),
                        overlayColor:
                            MaterialStateProperty.all<Color>(Color(0xFF3C91E6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
