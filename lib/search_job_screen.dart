import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/job_screen.dart';
import 'package:freelancing_app/job_widget.dart';

import 'bottom_nav_bar.dart';

class SearchJobScreen extends StatefulWidget {
  const SearchJobScreen({super.key});

  @override
  State<SearchJobScreen> createState() => _SearchJobScreenState();
}

class _SearchJobScreenState extends State<SearchJobScreen> {

  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = '';

  Widget _buildSearchField()
  {
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: InputDecoration(
        hintText: 'Search here for jobs...',

        prefixIcon: Icon(
          Icons.search,
        color: Colors.white70),

        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20)
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

  void _clearSearchQuery() {
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
  Widget build(BuildContext context) {
    return Scaffold(
      //     bottomNavigationBar: BottomNavBar(
      //     currentIndex: 0,
      // ),
      appBar: AppBar(
        title: _buildSearchField(),
        actions: _buildActions(),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,

        leading: IconButton(
          onPressed: ()
          {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobScreen()));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobTitle', isGreaterThanOrEqualTo: searchQuery)
              .where('recruitment', isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot)
          {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.data?.docs.isNotEmpty == true)
            {
              if(snapshot.data?.docs.isNotEmpty == true)
              {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index)
                    {
                      return JobWidget(
                          jobTitle: snapshot.data?.docs[index]['jobTitle'],
                          jobDescription: snapshot.data?.docs[index]['jobDescription'],
                          jobId: snapshot.data?.docs[index]['jobId'],
                          uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                          userImage: snapshot.data?.docs[index]['userImage'],
                          name: snapshot.data?.docs[index]['name'],
                          recruitment: snapshot.data?.docs[index]['recruitment'],
                          email: snapshot.data?.docs[index]['email'],
                          location: snapshot.data?.docs[index]['location']);
                    },
                );
              }
              else
              {
                return Center(child: Text('There is no jobs'));
              }
            }
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0 ),
              ),
            );
          }
      ),
    );
  }
}
