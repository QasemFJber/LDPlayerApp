import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingSubtitleWidget extends StatefulWidget {
  bool isFocused = false;
  String title;
  String subtitle;
  IconData icon;
  bool enabled;


  SettingSubtitleWidget({required this.isFocused, required this.title, required this.subtitle, required this.icon, required this.enabled});

  @override
  _SettingSubtitleWidgetState createState() => _SettingSubtitleWidgetState();
}

class _SettingSubtitleWidgetState extends State<SettingSubtitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 11

                  ),
                ),
                SizedBox(height:3),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.normal,
                      fontSize: 10
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 100,
            child: Center(
              child: Container(
                width: 60,
                child: Switch(
                  value: widget.enabled,
                  onChanged: (value){
                    setState(() {
                      widget.enabled = value;
                    });
                  },
                  activeTrackColor: Colors.purpleAccent,
                  activeColor: Colors.purple,
                  inactiveTrackColor: Colors.white70,
                ),
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color:  (widget.isFocused)?Colors.black:Colors.white.withOpacity(0),
      ),
    );
  }
}
