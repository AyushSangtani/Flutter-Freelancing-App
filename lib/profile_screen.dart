import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/checkuser.dart';
import 'package:freelancing_app/uihelper.dart';

import 'bottom_nav_bar.dart';
import 'loginpage.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;
  const ProfileScreen({required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLodaing = false;
  bool _isSameUser = false;

  void getUserData() async
  {
    try {
      _isLodaing = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();
      // ignore: unnecessary_null_comparison
      if (userDoc == null)
      {
        return;
      }
      else
      {
        setState(()
        {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phone');
          imageUrl = "https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg";
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          DateTime joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;

        setState(()
        {
          _isSameUser = _uid == widget.userID;
        });
      }
    }
    catch (error)
    {
      print(error);
    }
    finally
    {
      _isLodaing = false;
    }
  }

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  Widget userInfo({required IconData icon, required String context})
  {
    return Row(
      children: [

        Icon(
          icon,
          color: Colors.black,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            context,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  logout()
  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout Confirmation"),
          content: const Text("Are you sure you want to log out?"),
          actions: [

            TextButton(
              onPressed: () => Navigator.of(context).pop(),  // Cancel button
              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close dialog

                // Perform logout
                _auth.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout successful!')),
                );

                // Navigate to Login page and remove previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: _isLodaing
            ? Center(child: CircularProgressIndicator(),)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Stack(
                    children: [

                      Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 100),

                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name == null ? 'Name here' : name!,
                                  style: TextStyle(color: Colors.black, fontSize: 24.0),),
                              ),

                              SizedBox(height: 15),

                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),

                              SizedBox(height: 30),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Account Information :',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                              ),

                              SizedBox(height: 15),

                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: userInfo(icon: Icons.email, context: email),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: userInfo(icon: Icons.phone, context: phoneNumber),
                              ),

                              SizedBox(height: 20),

                              Divider(
                                thickness: 1,
                                color: Colors.grey,
                              ),

                              SizedBox(height: 20),

                              !_isSameUser
                                  ? Container()
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 30.0),
                                        child: MaterialButton(
                                          onPressed: () {
                                            logout();
                                          },
                                          color: Colors.black,
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(13),
                                          ),
                                          child: Padding(padding: const EdgeInsets.symmetric(vertical: 14),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [

                                                Text(
                                                  'Logout',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            width: size.width * 0.26,
                            height: size.width * 0.26,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 8,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),

                              image: DecorationImage(
                                  image: NetworkImage(
                                    // ignore: prefer_if_null_operators
                                    imageUrl == null
                                        ? 'https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg'
                                        : imageUrl,
                                  ),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),

    );
  }
}
