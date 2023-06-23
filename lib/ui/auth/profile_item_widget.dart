import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileItemWidget extends StatefulWidget {
  bool? isFocused = false;
  String? title;
  String? subtitle;
  IconData? icon;
  Function()? action;

  ProfileItemWidget({required this.isFocused, required this.title, required this.subtitle, required this.icon, required this.action});

  @override
  _ProfileItemWidgetState createState() => _ProfileItemWidgetState();
}

class _ProfileItemWidgetState extends State<ProfileItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:widget.action!,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 27,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title!,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 11

                    ),
                  ),
                  SizedBox(height:3),
                  Text(
                    widget.subtitle!,
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        decoration: BoxDecoration(
          color:  (widget.isFocused!)?Colors.black.withOpacity(0.5):Colors.white.withOpacity(0),
        ),
      ),
    );
  }
}
