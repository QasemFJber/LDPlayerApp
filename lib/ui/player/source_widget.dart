import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/source.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SourceWidget extends StatelessWidget {

  bool isFocused;

  Source source;

  SourceWidget({required this.isFocused, required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  color: (isFocused)? Colors.black.withOpacity(0.9) : Colors.white10,
                  margin: EdgeInsets.all(2),
                  child: getIcon(),
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                              margin: EdgeInsets.only(left:10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    source.title!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  if(source.size !=null)
                                  Text(
                                      source.size!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        fontWeight: FontWeight.normal
                                  ),
                                  )
                                ],
                              ),
                          ),
                        ),
                        if(source.quality !=null)
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(3)
                          ),
                          child: Text(
                              source.quality!,
                              style:TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    color: (isFocused)? Colors.black.withOpacity(0.9) : Colors.white10,
                    margin: EdgeInsets.all(2),
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  color: (isFocused)? Colors.black.withOpacity(0.9) : Colors.white10,
                  margin: EdgeInsets.all(2),
                  child: Icon(

                    (source.external!)? Icons.launch: Icons.play_arrow,
                      size:  (source.external!)? 25:40,
                      color: Colors.white,
                  ),
                ),
              ],
            ),
            if(source.premium == "2" || source.premium == "3")
             Positioned(
              right: 43,
              top: 15,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
    );
  }

  Widget getIcon() {
    if(source.type == "youtube"){
      return  Icon(
        FontAwesomeIcons.youtube,
        size: 35,
        color: Colors.white,
      );
  }else
      return  Container(
          margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          height: 30,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Center(
              child:
              Text(
                  source.type.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w900
                  ),
              )
          )
      );
  }
}
