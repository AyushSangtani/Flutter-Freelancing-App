import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/Add_Screen.dart';
import 'package:freelancing_app/filter_screen.dart';
import 'package:freelancing_app/profile_screen.dart';
import 'package:freelancing_app/search_screen.dart';
import 'job_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Prevent reloading the same page

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = JobScreen();
        break;
      case 1:
        nextScreen = SearchScreen();
        break;
      case 2:
        nextScreen = AddScreen();
        break;
      // case 3:
      //   nextScreen = FilterScreen();
      //   break;
      case 3:
        final FirebaseAuth _auth = FirebaseAuth.instance;
        final User? user = _auth.currentUser;
        final String uid = user!.uid;
        nextScreen = ProfileScreen(userID: uid);
        break;
      default:
        nextScreen = JobScreen();
    }

    // Navigate to the selected screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: Colors.black,
        iconSize: 25,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => _onItemTapped(context, index),
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          //BottomNavigationBarItem(icon: Icon(Icons.filter_list_rounded), label: 'Filter'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }
}