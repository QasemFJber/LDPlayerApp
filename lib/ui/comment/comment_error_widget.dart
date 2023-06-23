import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommentErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: Colors.black.withOpacity(0.7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.commentSlash,
                size: 80,
                color: Colors.white70,
              ),
              SizedBox(height: 25),
              Text("Something wrong !",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15
                ),
              ),
              SizedBox(height: 5),
              Text("Please check your internet connexion and try again  !",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 11
                ),
              )
            ],
          ),
      ),
    );
  }
}