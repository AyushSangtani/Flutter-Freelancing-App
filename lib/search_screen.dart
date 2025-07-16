import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/all_companies_widget.dart';

import 'bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = '';

  Widget _buildSearchField()
  {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: Colors.white,),
        hintText: 'Search here for profiles...',

        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        hintStyle: TextStyle(color: Colors.white),
      ),

      style: TextStyle(color: Colors.white, fontSize: 16),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions()
  {
    return <Widget>[
      IconButton(
          onPressed: () {
            _clearSearchQuery();
          },
          icon: Icon(Icons.clear))
    ];
  }

  void _clearSearchQuery()
  {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
      appBar: AppBar(
        title: _buildSearchField(),
        actions: _buildActions(),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),

      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if (snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black26,
                ),
              );
            }
            else if (snapshot.connectionState == ConnectionState.active)
            {
              if (snapshot.data!.docs.isNotEmpty)
              {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AllCompaniesWidget(
                        userId: snapshot.data!.docs[index]['uid'],
                        userName: snapshot.data!.docs[index]['name'],
                        userEmail: snapshot.data!.docs[index]['email'],
                        phoneNumber: snapshot.data!.docs[index]['phone'],
                        userImageUrl: 'https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg');
                  },
                );
              }
              else
              {
                return Center(child: Text('There is no users!'));
              }
            }
            return Center(child: Text('Something went wrong!'));
          }),
    );
  }
}
