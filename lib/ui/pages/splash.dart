import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'dart:math';

import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/ui/home/mylist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class Splash extends StatefulWidget  {
  @override
  _SplashState createState() => _SplashState();

}

class _SplashState extends State<Splash> with TickerProviderStateMixin {

  bool _p_1 = false;
  bool _p_2 = false;
  bool _p_3 = false;
  bool _p_4 = false;
  bool _p_5 = false;
  bool _p_6 = false;
  bool _p_7 = false;
  bool _p_8 = false;
  bool _p_9 = false;
  bool _p_10 = false;
  bool _p_11 = false;
  bool _p_12 = false;
  bool can_redirect = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSettings();
    _check();
    Future.delayed(Duration.zero,(){
      setState(() {
        _p_1= true;
      });
    });
    Future.delayed(Duration(milliseconds: 200),(){
      setState(() {
        _p_2= true;
      });
    });
    Future.delayed(Duration(milliseconds: 400),(){
      setState(() {
        _p_3= true;
      });
    });
    Future.delayed(Duration(milliseconds: 600),(){
      setState(() {
        _p_4= true;
      });
    });

    Future.delayed(Duration(milliseconds: 800),(){
      setState(() {
        _p_5= true;
      });
    });
    Future.delayed(Duration(milliseconds: 1000),(){
      setState(() {
        _p_6= true;
      });
    });
    Future.delayed(Duration(milliseconds: 1200),(){
      setState(() {
        _p_7= true;
      });
    });
    Future.delayed(Duration(milliseconds: 1400),(){
      setState(() {
        _p_8= true;
      });
    });
    Future.delayed(Duration(milliseconds: 1600),(){
      setState(() {
        _p_9= true;
      });
    });
    Future.delayed(Duration(milliseconds: 1800),(){
      setState(() {
        _p_10= true;
      });
    });
    Future.delayed(Duration(milliseconds: 2000),(){
      setState(() {
        _p_11= true;
      });
    });
    Future.delayed(Duration(milliseconds: 2200),(){
      setState(() {
        _p_12= true;
      });
    });
    Future.delayed(Duration(milliseconds: 5000),(){
      redirect();
    });
  }
  Future<String>  _check() async{

    var response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id_user =  0;
    if(prefs.getBool("LOGGED_USER") == true){
       id_user =  prefs.getInt("ID_USER");
    }
    response = await apiRest.check(0,id_user!);

    if (response != null) {
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var jsonData = convert.jsonDecode(response.body);
        var subscription = "X";
        for(Map i in jsonData["values"]){
          if(i["name"] == "subscription") {
            subscription =  i["value"];
          }
        }
        prefs.setString("NEW_SUBSCRIBE_ENABLED", subscription);
        if(jsonData["values"][1]["value"].toString() == "403"){
          logout();
        }
        redirect();
      }
    }else{
      redirect();
    }

    return "done";
  }
  redirect(){
    if(can_redirect){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Home(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }else{
      can_redirect= true;
    }
  }
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("LOGGED_USER") != null)
      Fluttertoast.showToast(
        msg: "You have logout in successfully !",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

    prefs.remove("ID_USER");
    prefs.remove("SALT_USER");
    prefs.remove("TOKEN_USER");
    prefs.remove("NAME_USER");
    prefs.remove("TYPE_USER");
    prefs.remove("USERNAME_USER");
    prefs.remove("IMAGE_USER");
    prefs.remove("EMAIL_USER");
    prefs.remove("DATE_USER");
    prefs.remove("GENDER_USER");
    prefs.remove("LOGGED_USER");


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(

        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: (_p_1)?0: MediaQuery.of(context).size.width,
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              color: Colors.red,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: (_p_2)? MediaQuery.of(context).size.width / 7: MediaQuery.of(context).size.width,
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width/7,
              color: Colors.teal,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: (_p_3)? (MediaQuery.of(context).size.width / 7)*2: MediaQuery.of(context).size.width,
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width/7,
              color: Colors.blueGrey,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: (_p_4)? (MediaQuery.of(context).size.width / 7)*3: MediaQuery.of(context).size.width,
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width/7,
              color: Colors.deepOrangeAccent,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: (_p_5)? (MediaQuery.of(context).size.width / 7)*4: MediaQuery.of(context).size.width,
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width/7,
              color: Colors.pinkAccent,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: (_p_6)? (MediaQuery.of(context).size.width / 7)*5: MediaQuery.of(context).size.width,
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width/7,
              color: Colors.redAccent,
            ),
          ), AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right: (_p_7)? (MediaQuery.of(context).size.width / 7)*6: MediaQuery.of(context).size.width,
            top: 0,
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width/7,
              color: Colors.deepPurple,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            right:(_p_9)? 0 : (MediaQuery.of(context).size.width / 7)*3,
            top: 0,
            left:(_p_9)? 0 : (MediaQuery.of(context).size.width / 7)*3,
            bottom: 0,
            child: Visibility(
              visible:  _p_8,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width:MediaQuery.of(context).size.width/7,
                color: Colors.deepOrangeAccent,
                child: AnimatedContainer(

                  duration: Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                          visible: _p_10,
                          child: Image.asset("assets/images/logo.png",width: 300,color: Colors.white)
                      ),
                      SizedBox(width: 20),
                      Visibility(
                        visible: _p_11,
                        child: Container(
                          width: 1,
                          height: 150,
                          color: Colors.white54,
                        ),
                      ),
                      Visibility(
                        visible: _p_11,
                        child: AnimatedContainer(
                            width: (_p_12)? 300 :0,
                            height: 200,
                            duration: Duration(milliseconds: 500),

                            child:   Stack(
                            children: [
                              AnimatedPositioned(
                                duration: Duration(milliseconds: 500),
                                left: (_p_12)? 20: -400,
                                top: 0,
                                child: Container(
                                  width: 300,
                                  height: 200,
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Free Movies \nTV Series and \nTV channels",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w900
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initSettings()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt("subtitle_size") == null){
      prefs.setInt("subtitle_size",33);
    }
    if(prefs.getInt("subtitle_color") == null){
      prefs.setInt("subtitle_color",1);
    }
    if(prefs.getInt("subtitle_background") == null){
      prefs.setInt("subtitle_background",0);
    }
    if(prefs.getBool("subtitle_enabled") == null){
      prefs.setBool("subtitle_enabled",false);
    }
  }
}
