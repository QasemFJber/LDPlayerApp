import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/auth/auth.dart';
import 'package:flutter_app_tv/ui/auth/profile.dart';
import 'package:flutter_app_tv/ui/channel/channels.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/ui/home/mylist.dart';
import 'package:flutter_app_tv/ui/movie/movies.dart';
import 'package:flutter_app_tv/ui/search/search.dart';
import 'package:flutter_app_tv/ui/serie/series.dart';
import 'package:flutter_app_tv/ui/setting/settings.dart';
import 'package:need_resume/need_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationWidget extends StatefulWidget {

  int? posty;
  int? postx;
  int? selectedItem;
  Image? image;
  bool? logged;

  NavigationWidget({this.posty, this.postx, this.selectedItem, this. image,this.logged});

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends ResumableState<NavigationWidget> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    getLogged();

  }
  getLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    widget.logged = await prefs.getBool("LOGGED_USER");

    if(widget.logged == true) {
      String? img = await prefs.getString("IMAGE_USER");
      widget.image = Image.network(img!);
    }else{
      widget.logged = false;
      widget.image = Image.asset("assets/images/profile.jpg");
    }
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
      left: 0,
      right: 0,
      top: (widget.posty!<0)? 0 : -100,
      duration: Duration(milliseconds: 200),
      child:  Container(
          child: Container(
            margin: EdgeInsets.only(left: 50,right: 50,top: 10),
            height:50,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    child:   Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child:  Image.asset("assets/images/logo.png"),
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              widget.postx = 0;
                              widget.posty = -2;
                              Future.delayed(Duration(milliseconds: 200),(){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation1, animation2) => Search(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                );
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7,vertical: 1),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:(widget.selectedItem == 0)? (widget.posty == -2 && widget.postx == 0)?Colors.white:Colors.white70:(widget.posty == -2 && widget.postx == 0)?Colors.white24:Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 20,
                                  color:(widget.selectedItem == 0)?Colors.black:(widget.posty == -2 && widget.postx == 0)?Colors.white:Colors.white60,
                                ),
                                SizedBox(width:5),
                                Text(
                                  "Search",
                                  style: TextStyle(
                                      color:(widget.selectedItem == 0)?Colors.black:(widget.posty == -2 && widget.postx == 0)?Colors.white:Colors.white60,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              widget.postx = 1;
                              widget.posty = -2;
                              Future.delayed(Duration(milliseconds: 200),(){
                                    if(widget.selectedItem != 1){
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1, animation2) => Home(),
                                          transitionDuration: Duration(seconds: 0),
                                        ),
                                      );
                                    }
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7,vertical: 1),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:(widget.selectedItem == 1)? (widget.posty == -2 && widget.postx == 1)?Colors.white:Colors.white70:(widget.posty == -2 && widget.postx == 1)?Colors.white24:Colors.transparent,
                            ),
                            child: Text(
                              "Home",
                              style: TextStyle(
                                  color:(widget.selectedItem == 1)?Colors.black:(widget.posty == -2 && widget.postx == 1)?Colors.white:Colors.white60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              widget.postx = 2;
                              widget.posty = -2;
                              Future.delayed(Duration(milliseconds: 200),(){
                                if(widget.selectedItem != 2){
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1, animation2) => Movies(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                  );
                                }
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7,vertical: 1),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 9),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              color:(widget.selectedItem == 2)? (widget.posty == -2 && widget.postx == 2)?Colors.white:Colors.white70:(widget.posty == -2 && widget.postx == 2)?Colors.white24:Colors.transparent,
                            ),
                            child: Text(
                              "Movies",
                              style: TextStyle(
                                  color:(widget.selectedItem == 2)?Colors.black:(widget.posty == -2 && widget.postx == 2)?Colors.white:Colors.white60,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              widget.postx = 3;
                              widget.posty = -2;
                              Future.delayed(Duration(milliseconds: 200),(){
                                if(widget.selectedItem != 3){
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1, animation2) => Series(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                  );
                                }
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7,vertical: 1),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 9),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              color:(widget.selectedItem == 3)? (widget.posty == -2 && widget.postx == 3)?Colors.white:Colors.white70:(widget.posty == -2 && widget.postx == 3)?Colors.white24:Colors.transparent,
                            ),
                            child: Text(
                              "Shows",
                              style: TextStyle(
                                  color:(widget.selectedItem == 3)?Colors.black:(widget.posty == -2 && widget.postx == 3)?Colors.white:Colors.white60,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              widget.postx = 4;
                              widget.posty = -2;
                              Future.delayed(Duration(milliseconds: 200),(){
                                if(widget.selectedItem != 4){
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1, animation2) => Channels(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                  );
                                }
                              });
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7,vertical: 1),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 9),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              color:(widget.selectedItem == 4)? (widget.posty == -2 && widget.postx == 4)?Colors.white:Colors.white70:(widget.posty == -2 && widget.postx == 4)?Colors.white24:Colors.transparent,
                            ),
                            child: Text(
                              "Live TV",
                              style: TextStyle(
                                  color:(widget.selectedItem == 4)?Colors.black:(widget.posty == -2 && widget.postx == 4)?Colors.white:Colors.white60,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              widget.postx = 5;
                              widget.posty = -2;
                                if(widget.logged != true){
                                    Future.delayed(Duration(milliseconds: 200),(){
                                      push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1, animation2) => Auth(),
                                          transitionDuration: Duration(seconds: 0),
                                        ),
                                      );
                                    });
                                }else{
                                  Future.delayed(Duration(milliseconds: 200),(){
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1, animation2) => MyList(),
                                        transitionDuration: Duration(seconds: 0),
                                      ),
                                    );
                                  });
                                }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 7,vertical: 1),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 9),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:(widget.selectedItem == 5)? (widget.posty == -2 && widget.postx == 5)?Colors.white:Colors.white70:(widget.posty == -2 && widget.postx == 5)?Colors.white24:Colors.transparent,
                            ),
                            child: Text(
                              "My List",
                              style: TextStyle(
                                  color:(widget.selectedItem == 5)?Colors.black:(widget.posty == -2 && widget.postx == 5)?Colors.white:Colors.white60,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.postx = 6;
                      widget.posty = -2;
                      Future.delayed(Duration(milliseconds: 200),(){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => Settings(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                      });
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 50,
                    width: 50,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (widget.posty == -2 && widget.postx == 6)?Colors.white24:Colors.transparent
                      ),
                      child: Icon(
                        (widget.posty == -2 && widget.postx == 6)?Icons.settings_sharp:Icons.settings_outlined,
                        size: 23,
                        color:(widget.posty == -2 && widget.postx == 6)?Colors.white:Colors.white60,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      widget.postx = 7;
                      widget.posty = -2;
                      if(widget.logged ==  true){

                        Future.delayed(Duration(milliseconds: 200),(){
                          push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => Profile(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        });
                      }else{
                        Future.delayed(Duration(milliseconds: 200),(){
                          push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => Auth(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        });
                      }

                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 50,
                    width: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border:(widget.posty == -2 && widget.postx == 7)? Border.all(color:Colors.white,width: 2): Border.all(width: 1,color:Colors.transparent),
                      ),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Container(
                            child: widget.image,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [BoxShadow(
                            color: Colors.black54.withOpacity(0.2),
                            offset: Offset(0,0),
                            blurRadius: 5
                        )]
                    ),
                  ),
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black87,Colors.black54,Colors.transparent],
              )
          )
      ),
    );
  }

}
