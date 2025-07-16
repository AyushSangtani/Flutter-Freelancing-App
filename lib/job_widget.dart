import 'package:flutter/material.dart';
import 'package:freelancing_app/global_var.dart';
import 'package:freelancing_app/job_details_screen.dart';

class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget(
      {required this.jobTitle,
      required this.jobDescription,
      required this.jobId,
      required this.uploadedBy,
      required this.userImage,
      required this.name,
      required this.recruitment,
      required this.email,
      required this.location});

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>JobDetailsScreen(
            uploadedBy: widget.uploadedBy,
            jobID: widget.jobId,
          )));
        },
        onLongPress: () {},
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border(
              //right: BorderSide(width: 1),
            ),
          ),

          // USER IMAGE
            height: 70,
            child: Image.network('https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg')

        ),

        //JOB TITLE TEXT
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // NAME TEXT
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: 8,
            ),

            // JOB DESCRIPTION TEXT
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ],
        ),

        // > ICON
        trailing: Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
