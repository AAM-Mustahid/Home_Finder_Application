import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_finder_app/UserProvider.dart';
import 'package:home_finder_app/constants.dart';
import 'package:provider/provider.dart';

class CreatePropertyPage extends StatefulWidget {
  @override
  _CreatePropertyPageState createState() => _CreatePropertyPageState();
}

class _CreatePropertyPageState extends State<CreatePropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rentFeeController = TextEditingController();
  final _featuresController = TextEditingController();
  final _locationController = TextEditingController();
  final _thanaController = TextEditingController();
  final _districtController = TextEditingController();
  final _propertyTypeController = TextEditingController();
  final _postedByController = TextEditingController();
  final _floorPlanImageController = TextEditingController();
  final _areaController = TextEditingController();
  final _bedController = TextEditingController();
  final _bathroomController = TextEditingController();
  final _statusController = TextEditingController();
  final _timestampController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserProvider>(context).userInfo;
    print("userInfo ${userInfo}");

    void _submitForm() async {
      if (_formKey.currentState!.validate()) {
        print("userInfo ${userInfo}");
        var dio = Dio();
        try {
          var response = await dio.post(
            '${Constants.server}/properties/create',
            data: {
              'Name': _nameController.text,
              'Description': _descriptionController.text,
              'RentFee': _rentFeeController.text,
              'Location': _locationController.text,
              'Thana': _thanaController.text,
              'District': _districtController.text,
              'Area': _areaController.text,
              'Bed': _bedController.text,
              'Bath': _bathroomController.text,
              'Status': 'Available',
              'Timestamp': DateTime.now().millisecondsSinceEpoch,
              'PostedBy': userInfo?['user'][0]['id'],
            },
          );
          if (response.statusCode == 200) {
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: "Successfully created propert",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Fluttertoast.showToast(
                msg: "Failed to create property",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity
                    .TOP, // This line makes the toast appear from the top
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          // Handle error
          print('error ${e.toString()}');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Property'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10), // Add space between fields
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // RentFee field
            TextFormField(
              controller: _rentFeeController,
              decoration: const InputDecoration(
                labelText: 'Rent Fee',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a rent fee';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // RentFee field
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Locations',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the location';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // RentFee field
            TextFormField(
              controller: _thanaController,
              decoration: const InputDecoration(
                labelText: 'Thana',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter thana';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // RentFee field
            TextFormField(
              controller: _districtController,
              decoration: const InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter district name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // RentFee field
            TextFormField(
              controller: _areaController,
              decoration: const InputDecoration(
                labelText: 'Area (sqft)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter total area';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // RentFee field
            TextFormField(
              controller: _bedController,
              decoration: const InputDecoration(
                labelText: 'Bed',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of bed';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // RentFee field
            TextFormField(
              controller: _bathroomController,
              decoration: const InputDecoration(
                labelText: 'Bath',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of bath';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitForm,
        child: Icon(Icons.check, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    );
  }
}
