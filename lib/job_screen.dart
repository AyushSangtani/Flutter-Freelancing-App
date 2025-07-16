import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/job_widget.dart';
import 'package:freelancing_app/search_job_screen.dart';
import 'bottom_nav_bar.dart';
import 'persistent.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;
  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx)
        {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Center(
              child: Text(
                "Job Category",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),

            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index)
                {
                  return InkWell(
                    onTap: ()
                    {
                      setState(()
                      {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print('jobCategoryList[index],${Persistent.jobCategoryList[index]}');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: ()
                {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
              TextButton(
                  onPressed: ()
                  {
                    setState(()
                    {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text(
                    'Cancel Filter',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
              ),
            ],
          );
        }
        );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context)
  {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0,),

      appBar: AppBar(
        title: Text("Jobs", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,

        //filter icon
        leading: IconButton(
            onPressed: ()
            {
              -_showTaskCategoriesDialog(size: size);
            },
            icon: Icon(Icons.filter_list_rounded)),

        //search icon
        actions: [
          IconButton(
            onPressed: ()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchJobScreen()));
            },
            icon: Icon(Icons.search_rounded),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobCategory', isEqualTo: jobCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
            {
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.connectionState == ConnectionState.active)
            {
              if (snapshot.data?.docs.isNotEmpty == true)
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
                        userImage: 'https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg',
                        //userImage: snapshot.data?.docs[index]['userImage'],
                        name: snapshot.data?.docs[index]['name'],
                        recruitment: snapshot.data?.docs[index]['recruitment'],
                        email: snapshot.data?.docs[index]['email'],
                        location: snapshot.data?.docs[index]['location']);
                  },//itemBuilder
                );
              }
              else
              {
                return Center( child: Text("There is no jobs!"),);
              }
            }
            return Center(child: Text(
              "Something went wrong",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)
            );
          }),
    );
  }
}
