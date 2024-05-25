import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:home_finder_app/UserProvider.dart';
import 'package:home_finder_app/constants.dart';
import 'package:home_finder_app/profile_pages/create_properties.dart';
import 'package:provider/provider.dart';

class MyPropertiesPage extends StatelessWidget {
  Future<List<dynamic>> fetchProperties(ID) async {
    var dio = Dio();
    final response = await dio
        .get('${Constants.server}/properties/getPropertiesById?id=${ID}');

    if (response.statusCode == 200) {
      print('my properties ${response.data}');
      return response.data;
    } else {
      throw Exception('Failed to load properties');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserProvider>(context).userInfo;

    print('userInfo ${userInfo}');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Properties'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProperties(
          userInfo?['user'][0]['id'],
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var property = snapshot.data?[index];
                  if (property != null) {
                    return Card(
                      child: ListTile(
                        title: Text(property['Name'] ?? 'No Name'),
                        subtitle: Text(
                          'Rent: ' +
                              (property['RentFee']?.toString() ??
                                  'No Rent Fee'),
                        ),
                        trailing: Text(property['Status'] ?? 'No Status'),
                      ),
                    );
                  } else {
                    return SizedBox
                        .shrink(); // return an empty widget if property is null
                  }
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePropertyPage(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
    );
  }
}
