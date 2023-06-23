import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReviewLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            width: double.infinity,
            color: Colors.black.withOpacity(0.7),
            child: Wrap(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                    margin: EdgeInsets.all(7),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(5)
                    )
                ),

                Container(
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                    margin: EdgeInsets.all(7),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(5)
                    )
                ),


                Container(
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                    margin: EdgeInsets.all(7),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(5)
                    )
                ),


                Container(
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 15),
                    margin: EdgeInsets.all(7),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(5)
                    )
                ),

                Container(
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                    margin: EdgeInsets.all(7),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(5)
                    )
                ),


              ],
            )
        )
    );
  }
}
