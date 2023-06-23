import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/api/api_config.dart';

class SubscribeDialog extends StatefulWidget {

  String url = "";

  Function close;
  bool visible;
  SubscribeDialog({required this.visible,required this.close}){
    url = apiConfig.api_url.replaceAll("/api/", "/subscription/subscribe.html");
  }

  @override
  _SubscribeDialogState createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Visibility(
        visible: widget.visible,
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: (){
                  widget.close();
                },
                child: Container(
                  color: Colors.black45,
                ),
              ),
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  boxShadow: [
                    BoxShadow(
                        color:Colors.black,
                        offset: Offset(0,0),
                        blurRadius: 5
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50,vertical: 20),
                  color:Colors.black.withOpacity(0.7),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                  "Be premium be free",
                                  style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 25
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Subscribe now. and enjoy an ad-free experiance ,and focus on the essential content",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.play_arrow,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Watch premium content",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.download,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Download premium content",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.directions_off,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Turn off all ads in all platforms",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [

                          Container(
                            width: 2,
                            color: Colors.white70,
                            height: 200,
                            margin: EdgeInsets.only(right: 10),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Subscribe now !",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 25
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(5),
                                  child: CachedNetworkImage(imageUrl: "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data="+widget.url,height: 100,width: 100)
                              ),
                              SizedBox(height: 10),

                              Text(
                                "Scan the QR Code or go to : \n"+widget.url+" \nand complete your subscription then restart the tv app !",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13
                                ),
                              ),
                              SizedBox(height: 10),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
