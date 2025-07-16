import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freelancing_app/job_screen.dart';
import 'package:freelancing_app/uihelper.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

import 'bottom_nav_bar.dart';
import 'comments_widget.dart';
import 'global_var.dart';

class JobDetailsScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobID;

  const JobDetailsScreen({
    required this.uploadedBy,
    required this.jobID,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int applicants = 0;
  bool isDeadlineAvailable = false;
  bool showComments = false;

  void getJobData() async
  {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null)
    {
      return;
    }
    else
    {
      setState(()
      {
        authorName = userDoc.get('name');
        // userImageUrl ='https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg';
        userImageUrl = userImage;
      });
    }

    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.jobID)
        .get();

    if (jobDatabase == null)
    {
      return;
    }
    else
    {
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        recruitment = jobDatabase.get('recruitment');
        emailCompany = jobDatabase.get('email');
        locationCompany = jobDatabase.get('location');
        applicants = jobDatabase.get('applicants');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('deadlineDateTimeStamp');
        deadlineDate = jobDatabase.get('deadlineDate');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      });

      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable = date.isAfter(DateTime.now());
    }
  }

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    getJobData();
  }

  Widget dividerWidget()
  {
    return Column(
      children: [
        SizedBox(height: 10),

        Divider(
          thickness: 1,
          color: Colors.grey,
        ),

        SizedBox(height: 10),
      ],
    );
  }

  applyForJob()
  {
    final Uri params = Uri(
      scheme: 'mailto',
      path: emailCompany,
      query: 'subject=Applying for $jobTitle&body=Hello, please attach Resume / CV file',
    );

    final url = params.toString();
    launchUrlString(url);
    addNewApplicant();
  }

  void addNewApplicant() async
  {
    var docRef = FirebaseFirestore.instance.collection('jobs').doc(widget.jobID);
    docRef.update({'applicants': applicants + 1,});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(currentIndex: 0,),
      appBar: AppBar(
        title: Text("Job Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: ()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobScreen()));
            },
            icon: Icon(Icons.close)),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // job details section
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          jobTitle == null ? 'null' : jobTitle!,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  userImageUrl == null
                                      ? "https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg"
                                      : userImageUrl!,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  authorName == null ? '' : authorName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),

                                SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  locationCompany!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      dividerWidget(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            applicants.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          SizedBox(width: 6),

                          Text(
                            'Applicants',
                            style: TextStyle(color: Colors.grey),
                          ),

                          SizedBox(width: 10),

                          Icon(
                            Icons.how_to_reg_sharp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      FirebaseAuth.instance.currentUser!.uid !=
                              widget.uploadedBy
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                dividerWidget(),

                                Text(
                                  'Recruitment',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),

                                SizedBox(height: 5),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    TextButton(
                                      onPressed: ()
                                      {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.uploadedBy) {
                                          try
                                          {
                                            FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({'recruitment': true});
                                          }
                                          catch (error)
                                          {
                                            UiHelper.CustomAlertBox(context, 'Action cannot be performed');
                                          }
                                        }
                                        else
                                        {
                                          UiHelper.CustomAlertBox(context, 'You cannot perform this action');
                                        }
                                        getJobData();
                                      },

                                      child: Text(
                                        'ON',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),

                                    Opacity(
                                      opacity: recruitment == true ? 1 : 0,
                                      child: Icon(
                                        Icons.check_box,
                                        color: Colors.green,
                                      ),
                                    ),

                                    SizedBox(width: 40),

                                    TextButton(
                                      onPressed: ()
                                      {
                                        User? user = _auth.currentUser;
                                        final _uid = user!.uid;
                                        if (_uid == widget.uploadedBy)
                                        {
                                          try
                                          {
                                            FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({'recruitment': false});
                                          }
                                          catch (error)
                                          {
                                            UiHelper.CustomAlertBox(context, 'Action cannot be performed');
                                          }
                                        }
                                        else
                                        {
                                          UiHelper.CustomAlertBox(context, 'You cannot perform this action');
                                        }
                                        getJobData();
                                      },

                                      child: Text(
                                        'OFF',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: recruitment == false ? 1 : 0,
                                      child: Icon(
                                        Icons.check_box,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                      dividerWidget(),

                      Text(
                        'Job Description',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        jobDescription == null ? '' : jobDescription!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),

                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),

            // job apply and due date section
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          isDeadlineAvailable
                              ? 'Actively Recruiting , Send CV/Resume: '
                              : 'Deadline Passed away.',
                          style: TextStyle(
                            color:
                                isDeadlineAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      SizedBox(height: 6),

                      Center(
                        child: UiHelper.CustomButton(()
                        {
                          applyForJob();
                        }, 'Apply Now'),
                      ),

                      dividerWidget(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            'Uploaded on: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),

                          Text(
                            postedDate == null ? '' : postedDate!,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            'Deadline Date: ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),

                          Text(
                            deadlineDate == null ? '' : deadlineDate!,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      dividerWidget(),
                    ],
                  ),
                ),
              ),
            ),

            //Comment section
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: Duration(
                          milliseconds: 500,
                        ),
                        child: _isCommenting
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: TextField(
                                      controller: _commentController,
                                      style: TextStyle(color: Colors.black),
                                      maxLength: 200,
                                      keyboardType: TextInputType.text,
                                      maxLines: 6,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.pink),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Flexible(
                                      child: Column(
                                    children: [

                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: MaterialButton(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                          onPressed: () async {
                                          if (_commentController.text.length <
                                              7) {
                                            UiHelper.CustomAlertBox(context,
                                                'Comment con not be less than 7 characters!');
                                          } else {
                                            final _generatedId = Uuid().v4();
                                            await FirebaseFirestore.instance
                                                .collection('jobs')
                                                .doc(widget.jobID)
                                                .update({
                                              'jobComments':
                                                  FieldValue.arrayUnion([
                                                {
                                                  'userId': FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                  'commentId': _generatedId,
                                                  'name': name,
                                                  'userImageUrl': userImage,
                                                  'commentBody':
                                                      _commentController.text,
                                                  'time': Timestamp.now(),
                                                }
                                              ]),
                                            });
                                            await Fluttertoast.showToast(
                                              msg:
                                                  'Your comment has been added!',
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.grey,
                                              fontSize: 18,
                                            );
                                            _commentController.clear();
                                          }
                                          setState(() {
                                            showComments = true;
                                          });
                                        }, child: Text('Post', style: TextStyle(
                                          color: Colors.white
                                        ),),),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isCommenting = !_isCommenting;
                                            showComments = false;
                                          });
                                        },
                                        child: Text('Cancel', style: TextStyle(
                                          color: Colors.black
                                        ),),
                                      ),
                                    ],
                                  )),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // icon btn comment
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isCommenting = !_isCommenting;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.add_comment,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),

                                  // icon btn drop down
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showComments = true;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.arrow_drop_down_circle,
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      showComments == false
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('jobs')
                                      .doc(widget.jobID)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.data == null) {
                                        const Center(
                                          child:
                                              Text('No Comments for this job'),
                                        );
                                      }
                                    }
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return CommentsWidget(
                                            commentId:
                                                snapshot.data!['jobComments']
                                                    [index]['commentId'],
                                            commenterId:
                                                snapshot.data!['jobComments']
                                                    [index]['userId'],
                                            commenterName:
                                                snapshot.data!['jobComments']
                                                    [index]['name'],
                                            commentBody:
                                                snapshot.data!['jobComments']
                                                    [index]['commentBody'],
                                            commenterImageUrl:
                                                snapshot.data!['jobComments']
                                                    [index]['userImageUrl']);
                                      },
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        );
                                      },
                                      itemCount:
                                          snapshot.data!['jobComments'].length,
                                    );
                                  }),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
