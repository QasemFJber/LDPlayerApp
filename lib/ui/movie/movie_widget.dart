import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/poster.dart';

class MovieWidget extends StatelessWidget {
  bool? isFocus ;
  Poster? movie ;
  MovieWidget({this.isFocus,this.movie});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: ClipRRect(child: CachedNetworkImage(
              imageUrl: movie!.image,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ), borderRadius: BorderRadius.circular(5)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.blueGrey,
              border: (isFocus!)?Border.all(color: Colors.purple,width: 2):Border.all(color: Colors.transparent,width: 0),
              boxShadow: [
                BoxShadow(
                    color: (isFocus!)?Colors.purple.withOpacity(0.9):Colors.white.withOpacity(0),
                    offset: Offset(0,0),
                    blurRadius: 5
                ),
              ],
            ),
            height: 170,
            width:100,
          ),
          Positioned(
            top: 10,
            left: 0,
            child: Container(
              height: 15,
              child: Row(
                children: [
                  if(movie!.label != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                    height: 15,
                    child:
                    Text(
                      movie!.label!,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(7),bottomRight: Radius.circular(7)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2,0),
                            blurRadius: 1
                        ),
                      ],
                    ),
                  ),
                  if(movie!.sublabel != null  )
                    Container(
                      padding: EdgeInsets.only(left: 4,right: 4,top: 2,bottom: 2),
                      child: Text(
                        movie!.sublabel!,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 10
                        ),
                      ),
                    )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(7),bottomRight: Radius.circular(7)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(2,0),
                      blurRadius: 1
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}