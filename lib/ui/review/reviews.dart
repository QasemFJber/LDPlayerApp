import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/model/comment.dart';
import 'package:flutter_app_tv/ui/home/home.dart' as mmm;
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/model/review.dart';
import 'package:flutter_app_tv/ui/review/revie_error_widget.dart';
import 'package:flutter_app_tv/ui/review/review_empty_widget.dart';
import 'package:flutter_app_tv/ui/review/review_loading_widget.dart';
import 'package:flutter_app_tv/ui/review/review_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert' as convert;

import 'package:transparent_image/transparent_image.dart';

class Reviews extends StatefulWidget {
  int id ;
  String title ;
  String image ;
  String type ;


  Reviews({required this.id,required this.image,required this.title,required this.type});

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  FocusNode main_focus_node = FocusNode();
  FocusNode  yxy_focus_node= FocusNode();
  List<Review> reviewsList  = [];




  int pos_x  =0;
  int pos_y = 0;

  ItemScrollController commentsScrollController = ItemScrollController();


  bool _visibile_loading = false;
  bool _visibile_error = false;
  bool _visibile_success = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(main_focus_node);
      _getList();
    });
  }

  void _getList()  async{
    reviewsList.clear();

    _showLoading();
    var response;
    if(widget.type == "channel")
       response =await apiRest.getReviewsByChannel(widget.id);
    else
      response =await apiRest.getReviewsByPoster(widget.id);

    if(response == null){
      _showTryAgain();
    }else{
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        List<Review> reviewsList_  = [];

        for(Map<String,dynamic> i in jsonData){

          Review review = Review.fromJson(i);
          reviewsList_.add(review);
        }

        for(Review r in reviewsList_.reversed){
          reviewsList.add(r);
        }


        _showData();
      } else {
        _showTryAgain();
      }
    }
    setState(() {

    });
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
                break;
              case KEY_UP:
                if(pos_x == 0){
                  if(pos_y  ==  0){
                    print("play sound");
                  }else{
                    pos_y --;
                  }
                }else{
                  print("play sound");

                }
                break;
              case KEY_DOWN:
                if(pos_x == 0){
                  if(pos_y  ==  reviewsList.length -1){
                    print("play sound");
                  }else{
                    pos_y ++;
                  }
                }else{
                  print("play sound");
                }

                break;
              case KEY_LEFT:
                print("play sound");


                break;
              case KEY_RIGHT:
                print("play sound");

                break;
              default:
                break;
            }
            setState(() {

            });
            print("here is  = "+ pos_x.toString() + " . "+pos_y.toString());
            if(pos_x == 0){
              commentsScrollController.scrollTo(index: pos_y,alignment: 0.43,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
            }

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
                    Text(widget.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900
                      ),
                    ),
                    Text("Reviews List"
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
              bottom: 0,
              top: 0,
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
                width: MediaQuery.of(context).size.width/3,
                child: Container(
                  width: double.infinity,
                  color: Colors.black45,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black45,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80.0,left: 10,bottom: 10),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.starHalfAlt,color: Colors.white70,size: 20),
                              SizedBox(width: 10),
                              Text(
                                "${reviewsList.length} Reviews",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white70
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if(_visibile_error)
                        ReviewErrorWidget(),
                      if(_visibile_loading)
                        ReviewLoadingWidget(),
                      if(_visibile_success)
                        if(reviewsList.length == 0)
                          ReviewEmptyWidget()
                        else
                      Expanded(child:
                      Container(
                        color: Colors.black.withOpacity(0.7),
                        child:  ScrollConfiguration(
                          behavior: mmm.MyBehavior(),
                          child: ScrollablePositionedList.builder(
                            itemCount: reviewsList.length,
                            itemScrollController: commentsScrollController,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return  ReviewWidget(isFocused: (index == pos_y && pos_x == 0),review : reviewsList[index]);
                            },
                          ),
                        ),
                      ))
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
  }

}
