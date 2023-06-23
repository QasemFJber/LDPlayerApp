import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  FocusNode main_focus_node = FocusNode();
  FocusNode username_focus_node= FocusNode();
  FocusNode password_focus_node= FocusNode();
  FocusNode confirm_password_focus_node= FocusNode();
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  bool oldvalide = true;
  bool passwordvalide = true;
  bool confirmpasswordvalide = true;
  bool loading = false;
  String _message_error = "";
  bool _visibile_error =false;
  int pos_y = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(username_focus_node);
    });
  }
  _changePassword() async{
    setState(() {
      loading = true;
      _visibile_error = false;

    });
    var response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id_user = prefs.getInt("ID_USER");
    response = await apiRest.changePassword(id_user!,oldPasswordController.text,passwordController.text);
    if (response != null) {
      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);
        if(jsonData["code"].toString() == "200"){

          String salt_user="0";
          String token_user="0";

          bool enabled = true;

          for(Map i in jsonData["values"]){
            print(i["name"]+" : "+ i["value"]);
            if(i["name"] == "salt") {
              salt_user =  i["value"];
            }
            if(i["name"] == "token") {
              token_user = i["value"];
            }
          }

          if (enabled == true ) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setString("SALT_USER", salt_user);
            prefs.setString("TOKEN_USER", token_user);

            prefs.setBool("LOGGED_USER", true);

            Fluttertoast.showToast(
              msg: "You password has been changed successfully !",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            _visibile_error = false;
            Navigator.pop(context);
          }else{
            _message_error = jsonData["message"];
            _visibile_error = true;
            Fluttertoast.showToast(
              msg: "Operation has been cancelled !",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        }else{
          _message_error = jsonData["message"];
          _visibile_error = true;
          Fluttertoast.showToast(
            msg: "Operation has been cancelled !",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );

        }
      }
    }else{
      _message_error =  "Operation has been cancelled !";
      _visibile_error = true;
      Fluttertoast.showToast(
        msg: "Operation has been cancelled !",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      loading = false;
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
                if(!loading)
                  _goToValidate();
                break;
              case KEY_UP:
                if(pos_y  ==  0){
                  print("play sound");
                }else{
                  pos_y --;
                }
                if(pos_y == 0){
                  FocusScope.of(context).requestFocus(null);
                  FocusScope.of(context).requestFocus(username_focus_node);
                }
                break;
              case KEY_DOWN:
                if(pos_y  ==  1){
                  print("play sound");
                }else{
                  pos_y ++;
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
          }
        },
        child: Stack(
          children: [
            FadeInImage(placeholder: MemoryImage(kTransparentImage),image:AssetImage("assets/images/background.jpeg"),fit: BoxFit.cover),
            ClipRRect( // Clip it cleanly.
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  alignment: Alignment.center,
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
                  color: Colors.black54,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset( "assets/images/logo.png",height: 40,color: Colors.white)),
                      SizedBox(height: 40),
                      Text(
                        "Change your password ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                          controller: oldPasswordController,
                          focusNode: username_focus_node,
                          textInputAction: TextInputAction.next,
                          obscureText:true,

                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                            labelText: 'Old password',
                            labelStyle: TextStyle(
                                color: (oldvalide)?Colors.white:Colors.red
                            ),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (oldvalide)?Colors.white:Colors.red,width: 1)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (oldvalide)?Colors.white54:Colors.red,width: 1)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (oldvalide)?Colors.white:Colors.red,width: 1)),
                            contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                            suffixIcon: Icon(
                              Icons.vpn_key_rounded,
                              size: 15,
                              color: (oldvalide)?Colors.white70:Colors.red,
                            ),
                          ),
                          style: TextStyle(
                            color: (oldvalide)?Colors.white:Colors.red,
                          ),
                          maxLines: 1,
                          minLines: 1,
                          scrollPadding: EdgeInsets.zero,
                          cursorColor: Colors.white,
                          onFieldSubmitted: (v){
                            if(oldPasswordController.text.length>=6){
                              oldvalide = true;
                            }else{
                              oldvalide = false;
                            }

                            setState(() {

                            });
                            FocusScope.of(context).requestFocus(password_focus_node);
                          }
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        focusNode: password_focus_node,
                        obscureText:true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          labelText: 'New Password',
                          labelStyle: TextStyle(
                              color: (passwordvalide)?Colors.white:Colors.red
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (passwordvalide)?Colors.white:Colors.red,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (passwordvalide)?Colors.white54:Colors.red,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (passwordvalide)?Colors.white:Colors.red,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                          suffixIcon: Icon(
                            Icons.vpn_key_rounded,
                            size: 15,
                            color: (passwordvalide)?Colors.white70:Colors.red,
                          ),
                        ),
                        style: TextStyle(
                          color: (passwordvalide)?Colors.white70:Colors.red,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,

                        onFieldSubmitted: (v){

                          if(passwordController.text.length>=6){
                            passwordvalide = true;
                          }else{
                            passwordvalide = false;

                          }

                          FocusScope.of(context).requestFocus(confirm_password_focus_node);
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: confirmPasswordController,
                        focusNode: confirm_password_focus_node,
                        obscureText:true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(
                              color: (confirmpasswordvalide)?Colors.white:Colors.red
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (confirmpasswordvalide)?Colors.white:Colors.red,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (confirmpasswordvalide)?Colors.white54:Colors.red,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (confirmpasswordvalide)?Colors.white:Colors.red,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                          suffixIcon: Icon(
                            Icons.vpn_key_rounded,
                            size: 15,
                            color: (confirmpasswordvalide)?Colors.white70:Colors.red,
                          ),
                        ),
                        style: TextStyle(
                          color: (confirmpasswordvalide)?Colors.white70:Colors.red,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,

                        onFieldSubmitted: (v){

                          if(confirmPasswordController.text.length>=6 && confirmPasswordController.text == passwordController.text){
                            confirmpasswordvalide = true;
                          }else{
                            confirmpasswordvalide = false;

                          }
                          setState(() {

                          });
                          FocusScope.of(context).requestFocus(main_focus_node);
                          pos_y= 1;
                          setState(() {

                          });
                        },
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
                      GestureDetector(
                        onTap: (){
                          pos_y = 1;
                          setState(() {

                          });
                          _goToValidate();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border:Border.all(color: (pos_y == 1)? Colors.white:  Colors.deepPurple,width: 2),
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (loading)?
                              Container(
                                  height:40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(4),topLeft: Radius.circular(4))
                                  ),
                                  child: Center(
                                    child: Container(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        )
                                    ),
                                  )
                              )
                                  :
                              Container(
                                  height:40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(4),topLeft: Radius.circular(4))
                                  ),
                                  child: Icon( FontAwesomeIcons.lock ,color: Colors.white)
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    (loading)?
                                    "Operation in progress ..."
                                        :
                                    "Change your password  !",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
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

  void _goToValidate() {
    if(pos_y == 1){

      if(oldPasswordController.text.length>=6){
        oldvalide = true;
      }else{
        oldvalide = false;
      }
      if(passwordController.text.length>=6){
        passwordvalide = true;
      }else{
        passwordvalide = false;

      }
      if(confirmPasswordController.text.length>=6 && confirmPasswordController.text == passwordController.text){
        confirmpasswordvalide = true;
      }else{
        confirmpasswordvalide = false;

      }
      setState(() {

      });

      if(passwordvalide && oldvalide && confirmpasswordvalide){
        _changePassword();
      }
    }
  }


}
