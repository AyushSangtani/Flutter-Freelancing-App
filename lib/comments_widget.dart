import 'package:flutter/material.dart';
import 'package:freelancing_app/profile_screen.dart';

class CommentsWidget extends StatefulWidget {
  final String commentId;
  final String commenterId;
  final String commenterName;
  final String commentBody;
  final String commenterImageUrl;

  CommentsWidget(
      {required this.commentId,
      required this.commenterId,
      required this.commenterName,
      required this.commentBody,
      required this.commenterImageUrl});

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  final List<Color> _colors = [
    Colors.amber,
    Colors.black26,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.blueAccent,
    Colors.deepOrange,
  ];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(userID: widget.commenterId)));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Flexible(
            flex: 1,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: _colors[1],
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.commenterImageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 6,
          ),

          Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.commenterName,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    widget.commentBody,
                    maxLines: 5,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}
