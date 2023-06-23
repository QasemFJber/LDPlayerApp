import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';
class ReviewAdd extends StatefulWidget {
  String type ;
  int id;
  String image;
  ReviewAdd({required this.type,required  this.id,required  this.image});

  @override
  _ReviewAddState createState() => _ReviewAddState();
}

class _ReviewAddState extends State<ReviewAdd> {
  FocusNode main_focus_node = FocusNode();
  FocusNode  yxy_focus_node= FocusNode();

  TextEditingController commentController = new TextEditingController();

  int pos_x  =0;
  int pos_y = 0;
  double _rating = 1;

  bool emptyText = false;
  bool _visibile_loading = false;
  bool _visibile_error = false;
  bool _visibile_success = false;
  String _message_success = "";
  String _message_error = "Please check your internet connexion and try again  !";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(main_focus_node);
    });
  }
  void _addReview()  async{
    if(pos_y == 2 ) {


      _showLoading();


      SharedPreferences prefs = await SharedPreferences.getInstance();

      int? id_user = await prefs.getInt("ID_USER");
      String? key_user = await prefs.getString("TOKEN_USER");
      String? userimage = await prefs.getString("IMAGE_USER");
      String? username = await prefs.getString("NAME_USER");

      String comment = commentController.text;

      var response;
      if (widget.type == "channel") {
        var comment_data = {
          "key": key_user,
          "user": id_user.toString(),
          "channel": widget.id.toString(),
          'review': comment,
          "value": _rating.toString()
        };
        response = await apiRest.addReviewChannel(comment_data);
      }else {
        var comment_data = {
          "key": key_user,
          "user": id_user.toString(),
          "poster": widget.id.toString(),
          'review': comment,
          "value":  _rating.toString()
        };
        response = await apiRest.addReviewPoster(comment_data);
      }
      print(response.body);
      if (response != null) {
        if (response.statusCode == 200) {
          var jsonData = convert.jsonDecode(response.body);
          if (jsonData["code"].toString() == "200") {
            _message_success = jsonData["message"];
            _showData();
            commentController.text = "";
          } else {
            _message_error = jsonData["message"];
            _showTryAgain();
          }
        } else {
          _showTryAgain();
        }
      } else {
        _showTryAgain();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:  RawKeyboardListener(
        focusNode: main_focus_node,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data as RawKeyEventDataAndroid;
            print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
            switch (rawKeyEventDataAndroid.keyCode) {
              case KEY_CENTER:
                  _setRating();
                  _addReview();
                break;
              case KEY_UP:
                  if(pos_y  ==  0){
                    print("play sound");
                  }else{
                    pos_y --;
                  }
                  if(pos_y == 1){
                    FocusScope.of(context).previousFocus();
                  }
                break;
              case KEY_DOWN:
                  if(pos_y  ==  2){
                    print("play sound");
                  }else{
                    pos_y ++;
                  }
                  if(pos_y == 1){
                    FocusScope.of(context).nextFocus();
                  }
                break;
              case KEY_LEFT:
                if(pos_y == 0){
                  if(pos_x == 0){
                    print("play sound");
                  }else{
                    pos_x--;
                  }
                }
                break;
              case KEY_RIGHT:
                  if(pos_y == 0){
                    if(pos_x == 1){
                        print("play sound");
                    }else{
                        pos_x++;
                    }
                  }
                break;
              default:
                break;
            }
            setState(() {

            });
          }
        },
        child: Stack(
          children: [
            FadeInImage(placeholder: MemoryImage(kTransparentImage),image:NetworkImage(widget.image),fit: BoxFit.cover,height: MediaQuery.of(context).size.height),
            ClipRRect( // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                ),
              ),
            ),
          Positioned(
            left: 0,
            bottom: 0,
            top: 0,
            child: Container(
              padding: EdgeInsets.only(right: 0),
              width: MediaQuery.of(context).size.width/1.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("JUST ME AND YOU !",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900
                    ),
                  ),
                  Text("Review this movie"
                    , style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.normal
                    ),),
                ],
              ),
            ),
          ),
            Positioned(
              right: 0,
              bottom: -5,
              top: -5,
              child: Container(
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
                width: MediaQuery.of(context).size.width/2.5,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(50),
                  color: Colors.black45,
                  child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    pos_x = 0 ; pos_y = 0;
                                    (_rating == 1)? _rating = 1: _rating--;
                                  });
                                },
                                child: Container(
                                  child: Icon(
                                    FontAwesomeIcons.angleLeft,
                                    size: 30,
                                    color: (pos_x == 0 && pos_y == 0)?Colors.white:Colors.white30,
                                  ),
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: _rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 35.0,
                                glowColor: Colors.amber,
                                glow: true,
                                unratedColor: Colors.white.withOpacity(0.5),
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (v){
                                  _rating = v;
                                },
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    pos_x = 1 ; pos_y = 0;
                                    (_rating == 5)? _rating = 5: _rating++;
                                  });
                                },
                                child: Container(
                                  child: Icon(
                                    FontAwesomeIcons.angleRight,
                                    size: 30,
                                    color: (pos_x == 1 && pos_y == 0)?Colors.white:Colors.white30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              border: Border.all(color:Colors.white),
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: TextField(
                              controller: commentController,
                              focusNode: yxy_focus_node,
                              textInputAction: TextInputAction.next,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: "Write your review here",
                                  hintStyle: TextStyle(
                                    color: Colors.white30
                                  )
                              ),
                              style: TextStyle(
                                    color: Colors.white,
                              ),
                              minLines: 5,
                              maxLines: 5,
                              cursorColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if(!_visibile_loading && !_visibile_success)
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  pos_y = 2;
                                  Future.delayed(Duration(milliseconds: 100),(){
                                    _addReview();
                                  });
                                });
                              },
                              child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white,width: 0.3),
                                borderRadius: BorderRadius.circular(5),
                                color: (pos_y == 2 )? Colors.white:Colors.white30,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 28,
                                    width: 28,
                                    child: Icon(
                                      FontAwesomeIcons.check,
                                      color: (pos_y == 2 )? Colors.black:Colors.white,
                                      size: 11,
                                    ),
                                  ),
                                  Text(
                                      "Send Review" ,
                                      style: TextStyle(
                                          color: (pos_y == 2 )? Colors.black:Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500
                                      )
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
                          ),
                            ),
                          if(_visibile_loading)
                            Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white,width: 0.3),
                                borderRadius: BorderRadius.circular(5),
                                color:  Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Container(
                                      padding: EdgeInsets.all(3),
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                      "Operation in progress" ,
                                      style: TextStyle(
                                          color:Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500
                                      )
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
                            ),
                          if(_visibile_error)
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red,width: 0.3),
                                borderRadius: BorderRadius.circular(5),
                                color:  Colors.redAccent,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    height: 28,
                                    width: 28,
                                    child: Icon(
                                      Icons.warning,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          _message_error ,
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if(_visibile_success)
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),

                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green,width: 0.3),
                                borderRadius: BorderRadius.circular(5),
                                color:  Colors.green,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5.0),
                                    height: 28,
                                    width: 28,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          _message_success,
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],

                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setRating() {
    if(pos_x == 0 && pos_y == 0){
      setState(() {

        (_rating == 1)? _rating = 1: _rating--;
      });
    }else if(pos_x == 1 && pos_y == 0){
      setState(() {
        (_rating == 5)? _rating = 5: _rating++;
      });
    }

  }
  void _showLoading() {
    setState(() {
      _visibile_loading = true;
      _visibile_error= false;
      _visibile_success= false;

    });
  }
  void _showTryAgain() {
    setState(() {
      _visibile_loading = false;
      _visibile_error= true;
      _visibile_success= false;

    });

  }
  void _showData() {
    setState(() {
      _visibile_loading = false;
      _visibile_error= false;
      _visibile_success= true;
    });
    Future.delayed(Duration(seconds: 3),(){
      setState(() {
        Navigator.pop(context);
      });
    });
  }
}
