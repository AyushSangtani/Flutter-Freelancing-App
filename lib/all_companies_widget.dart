import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freelancing_app/profile_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AllCompaniesWidget extends StatefulWidget {

  final String userId;
  final String userName;
  final String userEmail;
  final String phoneNumber;
  final String userImageUrl;

  AllCompaniesWidget({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.phoneNumber,
    required this.userImageUrl
});

  @override
  State<AllCompaniesWidget> createState() => _AllCompaniesWidgetState();
}


class _AllCompaniesWidgetState extends State<AllCompaniesWidget> {

  void _mailTo() async
  {
    final Uri params = Uri(
      scheme: 'mailto',
      path: widget.userEmail,
      query:
      'subject=Connecting with you &body=Hi, I wanted to reach out to you.',
    );
    final url = params.toString();
    launchUrlString(url);

    // var mailUrl = 'mailto:${widget.userEmail}';
    //
    // print('widget.userEmail ${widget.userEmail}');
    // if(await canLaunchUrlString(mailUrl)){
    //   await launchUrlString(mailUrl);
    // }
    // else{
    //   print('Error!');
    //   throw 'Error Occurred';
    // }
  }

  @override
  Widget build(BuildContext context)
  {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        onTap: ()
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(userID: widget.userId)));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            child: Image.network(
              // ignore: prefer_if_null_operators
              widget.userImageUrl == null
                  ?
              'https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg'
              :
              widget.userImageUrl
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Visit Profile',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: IconButton(
            onPressed: ()
            {
              _mailTo();
            },
            icon: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
        ),
      ),
    );
  }
}
