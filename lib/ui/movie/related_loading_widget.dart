import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RelatedLoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 7,top: 10),
                child: Container(
                  color: Colors.white70,
                  width: 100,
                  height: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child:  Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.white70,
                        height: 140,
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
    );
 ;
  }
}
