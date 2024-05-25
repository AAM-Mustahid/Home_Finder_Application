import 'package:flutter/material.dart';
import 'package:home_finder_app/home.dart';

class Property {
  final String Name;
  final String imageURL;
  final int bedroom;
  final int bathroom;
  final int livingArea;
  final String Description;
  final String address;
  final String rating;
  final String rentFee;

  Property({
    required this.Name,
    required this.imageURL,
    required this.bedroom,
    required this.bathroom,
    required this.livingArea,
    required this.Description,
    required this.address,
    required this.rating,
    required this.rentFee,
  });
}

class PropertyDetailsPage extends StatelessWidget {
  final Property property;

  PropertyDetailsPage(this.property);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4 - 30,
                  child: Container(), // Empty container
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.Name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on),
                          Text(property.address),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Icon(Icons.star),
                      //     Text('${property.rating}'),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Text(property.Description),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      Container(
                        height: 150,
                        child: Image.asset('assets/images/map.png',
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\BDT ${property.rentFee}/Month',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your reservation logic here
                        },
                        child: Text(
                          'Reserve',
                          style: TextStyle(
                              color:
                                  Colors.white), // Set the text color to white
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF2563EB)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4 + 10,
                  child: Image.network(property.imageURL, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 40.0,
                left: 10.0,
                child: Material(
                  // Wrap IconButton with Material
                  color: Colors.transparent, // Make Material transparent
                  child: Container(
                    width: 40.0, // Set the width of the container
                    height: 40.0, // Set the height of the container
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print('GestureDetector tapped');
                      },
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        iconSize: 20.0,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
