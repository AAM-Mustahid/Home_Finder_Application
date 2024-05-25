import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_finder_app/PropertyDetailsPage.dart';
import 'package:home_finder_app/decor.dart';
import 'package:home_finder_app/designer.dart';
import 'package:home_finder_app/layout.dart';
import 'package:home_finder_app/login.dart';
import 'package:home_finder_app/shifting.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:home_finder_app/UserProvider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<dynamic> properties = [];

  @override
  void initState() {
    super.initState();
    fetchProperties();
    // Add a listener to the controller.
    _controller.addListener(_onSearchChanged);
  }

  Future<List<dynamic>> fetchProperties() async {
    var dio = Dio();
    final response = await dio.get(
        '${Constants.server}/properties/getAll?page=1&limit=10&sortOrder=asc');

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to load products');
    }
  }

  List<bool> isSelected = [true, false]; // 'Rent' is selected by default
  bool isFavorited = false;

  // Create a TextEditingController.
  final TextEditingController _controller = TextEditingController();

  void _onSearchChanged() {
    // Make a call to the backend with the text the user typed.
    searchProperties(_controller.text);
  }

  var searchresults = [];

  void searchProperties(String query) async {
    // Replace with your backend URL.
    const String url = '${Constants.server}/properties/getByThana';

    Dio dio = Dio();

    try {
      // Make a GET request to the backend with the query as a parameter.
      Response response = await dio.get(url, queryParameters: {'thana': query});

      // If the server returns a 200 OK response, parse the JSON.
      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, then parse the JSON.
        searchresults = response.data;
        print("searchresults ${searchresults}");
        // Do something with the properties.
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load properties');
      }
    } catch (e) {
      // Handle any errors that occur during the request.
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF2F3F5),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: TextField(
                controller: _controller, // Set the controller.
                decoration: const InputDecoration(
                  hintText: 'Search location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications, size: 30.0),
            onPressed: () {
              Fluttertoast.showToast(
                  msg: "No new notifications",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity
                      .TOP, // This line makes the toast appear from the top
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: fetchProperties,
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                color: Color(0xFF818181),
                selectedColor: Colors.white,
                fillColor: isSelected[0]
                    ? Colors.blueAccent
                    : isSelected[1]
                        ? Colors.blueAccent
                        : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                borderWidth: 1,
                borderColor: Color(0xFFB9B9B9),
                selectedBorderColor: Colors.blueAccent,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Rent',
                      style: TextStyle(
                        color: isSelected[0] ? Colors.white : Color(0xFF818181),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Buy',
                      style: TextStyle(
                        color: isSelected[1] ? Colors.white : Color(0xFF818181),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            FutureBuilder<List<dynamic>>(
              future:
                  fetchProperties(), // Assuming you have a function that fetches the properties
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      height: 600,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SpinKitFadingCircle(
                            color: Color(0xFF2563EB),
                            size: 50.0,
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var properties = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: searchresults.isNotEmpty
                          ? searchresults.length
                          : properties?.length,
                      itemBuilder: (context, index) {
                        var propertyMap = searchresults.isNotEmpty
                            ? searchresults[index]
                            : properties != null && properties.length > index
                                ? properties[index]
                                : {};

                        Map<String, dynamic> propertyInfo =
                            jsonDecode(propertyMap['PropertyInfo']);
                        int bed = propertyInfo['Bed'];
                        int bath = propertyInfo['Bathroom'];
                        int area = propertyInfo['Area'];
                        // print('propertyMap: $propertyMap');
                        String imagesString = propertyMap['Images'] ?? '';
                        List<dynamic> imagesList = imagesString.isNotEmpty
                            ? jsonDecode(imagesString)
                            : [];
                        print("imagesList: $imagesList");
                        var property = Property(
                            Name: propertyMap['Name'] ?? '',
                            imageURL: imagesList.isNotEmpty
                                ? imagesList[0]
                                : 'https://i.ibb.co/VWzpdMG/home-design-1.jpg',
                            bedroom: bed,
                            bathroom: bath,
                            livingArea: area,
                            Description: propertyMap['Description'] ?? '',
                            address: propertyMap['Location'] ?? '',
                            rating: propertyMap['Reviews'] ?? '',
                            rentFee: (propertyMap['RentFee'] ??
                                    '4.3 rating (50 reviews)')
                                .toString());
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Stack(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PropertyDetailsPage(property)),
                                      );
                                    },
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      elevation:
                                          0.0, // This line removes the shadow
                                      child: Column(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: SizedBox(
                                              height: 300,
                                              width: double.infinity,
                                              child: Image.network(
                                                imagesList.isNotEmpty
                                                    ? imagesList[0]
                                                    : 'https://i.ibb.co/VWzpdMG/home-design-1.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              propertyMap['Name'] ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Text('Bedroom'),
                                                  Text(bed.toString()),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Text('Bathroom'),
                                                  Text(bath.toString()),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Text('Living Area'),
                                                  Text(area.toString()),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Text('Thana'),
                                                  Text(propertyMap['thana'] ??
                                                      ''),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20.0),
                                  Positioned(
                                    top: 20.0,
                                    right: 20.0,
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            icon: Icon(
                                                isFavorited
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                isFavorited = !isFavorited;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
