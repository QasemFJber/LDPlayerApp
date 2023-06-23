import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingColorWidget extends StatefulWidget {
  bool isFocused = false;
  String title;
  String subtitle;
  IconData icon;
  int color;



  List<Color> _list_text_color = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.purple,
    Colors.pink,
    Colors.teal
  ];
  SettingColorWidget({required this.isFocused, required this.title, required this.subtitle, required this.icon, required this.color});

  @override
  _SettingColorWidgetState createState() => _SettingColorWidgetState();
}

class _SettingColorWidgetState extends State<SettingColorWidget> {
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
          SizedBox(
            height: 50,
            child: Container(
                child: Row(
                  children: [

                    Container(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            if(widget.color>0)
                              widget.color--;
                            else
                              widget.color = 10;

                            setColor(widget.color);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white70,width: 3),
                        borderRadius: BorderRadius.circular(50),
                        color: widget._list_text_color[widget.color],


                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            if(widget.color<10)
                              widget.color++;
                            else
                              widget.color = 0;

                            setColor(widget.color);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
  void setColor(int color) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("subtitle_color", color);
  }
}
