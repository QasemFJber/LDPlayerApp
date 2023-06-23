import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeasonLoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 10,left: 50,right: 50),
            child:  Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    color: Colors.white70,
                    height: 35,
                  ),
                ),
              ],
            ),
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(bottom: 10,left: 50,right: 50),
          child:  Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white70,
                  height: 130,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  color: Colors.white70,
                  height: 130,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  color: Colors.white70,
                  height: 130,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  color: Colors.white70,
                  height: 130
                ),
              ),
            ],
          ),
        ),
      ],
    );
    ;
  }
}
