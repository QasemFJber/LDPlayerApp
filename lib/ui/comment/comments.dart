import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/model/comment.dart';
import 'package:flutter_app_tv/ui/auth/auth.dart';
import 'package:flutter_app_tv/ui/comment/comment_add.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/comment/comment_empty_widget.dart';
import 'package:flutter_app_tv/ui/comment/comment_error_widget.dart';
import 'package:flutter_app_tv/ui/comment/comment_loading_widget.dart';
import 'package:flutter_app_tv/ui/comment/comment_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:need_resume/need_resume.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class Comments extends StatefulWidget {
   int? id ;
   bool? enabled  = false;
   String? title ;
   String? image ;
   String? type ;



   Comments({ this.id,  this.enabled, this.image, this.type, this.title});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends ResumableState<Comments> {
  FocusNode main_focus_node = FocusNode();
  FocusNode  yxy_focus_node= FocusNode();

  List<Comment> commentsList  = [];
  int pos_x  =0;
  int pos_y = 0;


  bool _visibile_loading = false;
  bool _visibile_error = false;
  bool _visibile_success = false;

  ItemScrollController commentsScrollController = ItemScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(main_focus_node);
      _getList();
    });
  }

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    _getList();

  }
  void _getList()  async{
    commentsList.clear();

      _showLoading();
    var response;
    if(widget.type == "channel")
      response =await apiRest.getCommentsByChannel(widget.id!);
    else
      response =await apiRest.getCommentsByPoster(widget.id!);


    if(response == null){
      _showTryAgain();
    }else{
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        List<Comment> commentsLists  = [];

        for(Map<String,dynamic> i in jsonData){
          Comment comment = Comment.fromJson(i);
          commentsLists.add(comment);
        }
        for(Comment c in commentsLists.reversed){
          commentsList.add(c);
        }

        _showData();
      } else {
        _showTryAgain();
      }
    }
    setState(() {

    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:  RawKeyboardListener(
        focusNode: main_focus_node,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid =rawKeyDownEvent.data as RawKeyEventDataAndroid;
            print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
            switch (rawKeyEventDataAndroid.keyCode) {
              case KEY_CENTER:
                goToComment();
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
                  if(pos_y  ==  commentsList.length -1){
                    print("play sound");
                  }else{
                    pos_y ++;
                  }
                }else{
                  print("play sound");
                }

                break;
              case KEY_LEFT:
                (widget.enabled!)? (pos_x == -1)? print("play sound"): pos_x--:print("play sound");
                break;
              case KEY_RIGHT:
                (pos_x == 0)? print("play sound"): pos_x++;
                break;
              default:
                break;
            }
            setState(() {

            });
            print("here is  = "+ pos_x.toString() + " . "+pos_y.toString());
            if(pos_x == 0){
              commentsScrollController.scrollTo(index: pos_y,alignment: 0.34,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
            }

          }
        },
        child: Stack(
          children: [
            FadeInImage(placeholder: MemoryImage(kTransparentImage),image:NetworkImage(widget.image!),fit: BoxFit.cover,height: MediaQuery.of(context).size.height),
            ClipRRect( // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                ),
              ),
            ),
            if(widget.enabled!)
            Positioned(
              right:MediaQuery.of(context).size.width/3 + 20,
              bottom: 20,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    pos_x =-1;
                    goToComment();
                  });
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border:(pos_x == -1)? Border.all(color: Colors.white,width: 1): Border.all(color: Colors.deepPurple,width: 1),
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color:Colors.deepPurple,
                          offset: Offset(0,0),
                          blurRadius: 1
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Add Comment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
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
                    Text(widget.title!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900
                      ),
                    ),
                    Text("Comments List"
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
                              Icon(FontAwesomeIcons.solidComments,color: Colors.white70,size: 20),
                              SizedBox(width: 10),
                              Text(
                                commentsList.length.toString()+" Comments",
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
                        CommentErrorWidget(),
                      if(_visibile_loading)
                        CommentLoadingWidget(),
                      if(_visibile_success)
                        if(commentsList.length == 0)
                          CommentEmptyWidget()
                      else
                        Expanded(child:
                          Container(
                            color: Colors.black.withOpacity(0.7),
                            child:  ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ScrollablePositionedList.builder(
                                itemCount: commentsList.length,
                                itemScrollController: commentsScrollController,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return  CommentWidget(isFocused: (index == pos_y && pos_x == 0),comment:commentsList[index]);
                                },
                              ),
                            ),
                          )
                        )
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
  void goToComment() async{
    bool? logged= false;
    if(pos_x == -1 ){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      logged = prefs.getBool("LOGGED_USER");

      if(logged == true){
        push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => CommentAdd(image: widget.image!,type: widget.type!,id: widget.id!),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      }else{
        push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Auth(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      }

    }
  }

}
