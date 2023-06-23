import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewWidget extends StatelessWidget {
  bool isFocused = false;

  Review review;

  ReviewWidget({required this.isFocused,required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
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
            margin: EdgeInsets.only(right: 5,bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color:Colors.white,width: 1),
            ),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(review.image),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.user,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(FontAwesomeIcons.clock,size: 7,color: Colors.white54,),
                                    SizedBox(width: 5),
                                    Text(
                                      review.created,
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 7,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${dp(review.rating,1)}/5", style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800
                            ),),
                            RatingBar.builder(
                              initialRating: dp(review.rating,1),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 12.0,
                              ignoreGestures: true,
                              unratedColor: Colors.amber.withOpacity(0.4),
                              itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if(review.content != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 10,top: 5),
                    child: Text(
                      review.content!,
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 8,
                          fontWeight: FontWeight.normal,
                          height: 1.2
                      ),
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
  double dp(double val, int places){
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }
}
