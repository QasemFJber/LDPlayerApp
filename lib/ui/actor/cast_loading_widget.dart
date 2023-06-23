import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CastLoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
                  margin: EdgeInsets.only(left:(index == 0)?50: 0,right: 10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(50)
                  ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left:(index == 0)?50: 0,right: 10),
              height: 10,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(2)
              ),
            ),
            SizedBox(height: 5),
            Container(
              margin: EdgeInsets.only(left:(index == 0)?50: 0,right: 10),
              height: 10,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(2)
              ),
            ),
          ],
        );
      },
    );
  }
}
