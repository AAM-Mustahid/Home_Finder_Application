// ProfileMenus.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_finder_app/UserProvider.dart';
import 'package:home_finder_app/profile_pages/my_properties.dart';
import 'package:home_finder_app/profile_pages/personal_info_page.dart';
import 'package:home_finder_app/profile_pages/rent_management.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfileMenu extends StatelessWidget {
  final User? user;

  ProfileMenu({Key? key, this.user}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    print('user ${user}');
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(left: 16, right: 16),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Hi ${toBeginningOfSentenceCase(user!.displayName)}',
                style: TextStyle(fontSize: 24, color: Colors.blueAccent)),
          ),
          const Divider(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PersonalInfoPage()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.person),
              title: Text('Personal Info'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RentManagementPage()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.home),
              title: Text('Rent management'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPropertiesPage()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.location_city),
              title: Text('My Properties'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.lock),
              title: Text('Privacy'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payments & payouts'),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {},
            child: const ListTile(
              leading: Icon(Icons.security),
              title: Text('Login & Security'),
            ),
          ),
          const Divider(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent, // background color
            ),
            onPressed: () async {
              await _auth.signOut();
              Provider.of<UserProvider>(context, listen: false).user = null;
            },
            child: Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
