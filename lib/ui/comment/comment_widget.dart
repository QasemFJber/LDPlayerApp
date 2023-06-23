import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/comment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentWidget extends StatelessWidget {
  bool isFocused = false;
  Comment comment ;

  CommentWidget({required this.isFocused, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
      margin: EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
        border: (isFocused)? Border.all(color: Colors.white,width: 1): Border.all(color: Colors.white10,width: 1),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            width: 25,
            margin: EdgeInsets.only(right: 5,bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color:Colors.white,width: 1),
            ),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(comment.image),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                            child: Text(
                              comment.user,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Row(
                          children: [
                            Icon(FontAwesomeIcons.clock,size: 8,color: Colors.white54,),
                            SizedBox(width: 5),
                            Text(
                              comment.created,
                                style: TextStyle(
                                  color: Colors.white70,
                                    fontSize: 8,
                                    fontWeight: FontWeight.normal
                                ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    (comment.enabled)?comment.clear:"Comment as been hided by admin !",
                    style: TextStyle(
                        color: (comment.enabled)? Colors.white70:Colors.white38,
                        fontSize: 8,
                        fontWeight: FontWeight.normal,
                        height: 1.2
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
