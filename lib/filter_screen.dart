import 'package:flutter/material.dart';

import 'bottom_nav_bar.dart';
import 'main.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      appBar: AppBar(
        title: Text("Filter Screen", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),

      body: Container(
        width: double.maxFinite,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Filter Screen"),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "log out")));
            }, child: Text("LogOut"))
          ],
        ),
      ),
    );
  }
}
