import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/actor.dart';

class CastWidget extends StatefulWidget {

  int index;
  int postx;
  int posty;
  int active_y;
  Actor actor;

  CastWidget({required this.index, required this.postx, required this.posty,required this.actor,required this.active_y});

  @override
  _CastWidgetState createState() => _CastWidgetState();
}

class _CastWidgetState extends State<CastWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left:(widget.index == 0)?50: 0,right: 10),
      child: Column(
        children: [
          Container(
            height: 40,
            width: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border:(widget.posty == widget.active_y && widget.postx == widget.index)? Border.all(color:Colors.purple,width: 2): Border.all(width: 1,color:Colors.transparent),
                boxShadow: [
                  BoxShadow(
                      color: (widget.posty == widget.active_y && widget.postx == widget.index)?Colors.purple.withOpacity(0.9):Colors.white.withOpacity(0),
                      offset: Offset(0,0),
                      blurRadius: 5
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.actor.image),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [BoxShadow(
                    color: Colors.black54.withOpacity(0.1),
                    offset: Offset(0,0),
                    blurRadius: 3
                )]
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
                widget.actor.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
          Center(
            child: Text(
                widget.actor.role,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 7,
                    fontWeight: FontWeight.normal
                )
            ),
          ),
        ],
      ),
    );
  }
}
