import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_finder_app/UserProvider.dart';
import 'package:home_finder_app/decor.dart';
import 'package:home_finder_app/designer.dart';
import 'package:home_finder_app/home.dart';
import 'package:home_finder_app/login.dart';
import 'package:home_finder_app/shifting.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class MyLayout extends StatefulWidget {
  const MyLayout({super.key});

  @override
  State<MyLayout> createState() => Layout();
}

class Layout extends State<MyLayout> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPages;
  late HomePage homepage;
  late ShiftingPage shifting;
  late DecorPage decor;
  late DesignerPage designer;
  late LoginPage profile;

  @override
  void initState() {
    homepage = HomePage();
    shifting = ShiftingPage();
    decor = DecorPage();
    designer = DesignerPage();
    profile = LoginPage();
    pages = [homepage, shifting, designer, decor, profile];
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentTabIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            haptic: true, // haptic feedback
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.grey.shade200,
            gap: 8,
            padding: EdgeInsets.all(16),
            duration: Duration(milliseconds: 200),
            onTabChange: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.list,
                text: 'Home',
              ),
              GButton(
                icon: Icons.compare_arrows,
                text: 'Shifting',
              ),
              GButton(
                icon: Icons.people,
                text: 'Designers',
              ),
              GButton(
                icon: Icons.ac_unit_outlined,
                text: 'Decor',
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
