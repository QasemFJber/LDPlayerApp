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

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FocusNode main_focus_node = FocusNode();
  FocusNode username_focus_node= FocusNode();
  FocusNode name_focus_node= FocusNode();
  FocusNode password_focus_node= FocusNode();
  FocusNode confirm_password_focus_node= FocusNode();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  bool emailvalide = true;
  bool passwordvalide = true;
  bool confirmpasswordvalide = true;
  bool namevalide = true;
  bool accept = true;
  bool loading = false;
  String _message_error = "";
  bool _visibile_error =false;

  int pos_y = 0;
  bool privacy = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(username_focus_node);
    });
  }
   _register(String username,String email,String password,String image,String name,String type) async{
    setState(() {
      loading = true;
    });
    var response;
    var body =  {'username': username,'email':email, 'password': password,'name': name,"image":image,"type":type};

    response = await apiRest.registerUser( body);
    if (response != null) {
      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);
        if(jsonData["code"] == 200){
          int id_user=0;
          String name_user="x";
          String username_user="x";
          String email_user="";
          String subscribed_user="FALSE";
          String salt_user="0";
          String token_user="0";
          String type_user="x";
          String image_user="x";
          bool enabled = false;

          for(Map i in jsonData["values"]){
            if(i["name"] == "salt") {
              salt_user =  i["value"];
            }
            if(i["name"] == "token") {
              token_user = i["value"];
            }
            if(i["name"] == "id") {
              id_user = i["value"];
            }
            if(i["name"] == "name") {
              name_user = i["value"];
            }
            if(i["name"] == "type") {
              type_user = i["value"];
            }
            if(i["name"] == "username") {
              username_user =  i["value"];
            }
            if(i["name"] == "url") {
              image_user  = i["value"] ;
            }
            if(i["name"] == "enabled") {
              enabled = i["value"];
            }

            if(i["name"] == "subscribed") {
              subscribed_user = i["value"];
            }


          }

          if (enabled == true ) {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.setInt("ID_USER", id_user);
            prefs.setString("SALT_USER", salt_user);
            prefs.setString("TOKEN_USER", token_user);
            prefs.setString("NAME_USER", name_user);
            prefs.setString("TYPE_USER", type_user);
            prefs.setString("USERNAME_USER", username_user);
            prefs.setString("IMAGE_USER", image_user);
            prefs.setString("EMAIL_USER", email_user);
            prefs.setString("NEW_SUBSCRIBE_ENABLED", subscribed_user);
            prefs.setBool("LOGGED_USER", true);
            Fluttertoast.showToast(
              msg: "You have logged in successfully !",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
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

                  _goToValidate();
                _accept();
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
                if(pos_y  ==  3){
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

                      Text(
                        "Sign up for free !",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: usernameController,
                        focusNode: username_focus_node,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: (emailvalide)?Colors.white:Colors.red,
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                              color: (emailvalide)?Colors.white:Colors.red
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (emailvalide)?Colors.white:Colors.red,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (emailvalide)?Colors.white54:Colors.red,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color:(emailvalide)?Colors.white:Colors.red,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          isDense: true,

                          suffixIcon: Icon(
                            Icons.mail,
                            size: 15,
                            color: (emailvalide)?Colors.white70:Colors.red,
                          ),
                        ),
                        style: TextStyle(
                          color: (emailvalide)?Colors.white:Colors.red,

                        ),
                        maxLines: 1,
                        minLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,
                        onFieldSubmitted: (v){
                          FocusScope.of(context).requestFocus(name_focus_node);
                          if(checkEmail(usernameController.text)){
                            emailvalide = true;
                          }else{
                            emailvalide = false;
                          }
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        focusNode: name_focus_node,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          focusColor: (namevalide)?Colors.white:Colors.red,
                          labelText: 'Full name',
                          labelStyle: TextStyle(
                              color: (namevalide)?Colors.white:Colors.red
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (namevalide)?Colors.white:Colors.red,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (namevalide)?Colors.white54:Colors.red,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (namevalide)?Colors.white:Colors.red,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                          suffixIcon: Icon(
                            Icons.text_fields,
                            size: 15,
                            color: (namevalide)?Colors.white70:Colors.red,
                          ),
                        ),
                        style: TextStyle(
                          color: (namevalide)?Colors.white:Colors.red,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,
                        onFieldSubmitted: (v){
                          if(nameController.text.length>=3){
                            namevalide = true;
                          }else{
                            namevalide = false;
                          }
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,

                        focusNode: password_focus_node,
                        obscureText:true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          focusColor: (!passwordvalide)?Colors.red:Colors.white,
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: (!passwordvalide)?Colors.red:Colors.white
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (!passwordvalide)?Colors.red:Colors.white,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (!passwordvalide)?Colors.red:Colors.white54,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (!passwordvalide)?Colors.red:Colors.white,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                          suffixIcon: Icon(
                            Icons.vpn_key_rounded,
                            size: 15,
                            color: (!passwordvalide)?Colors.red:Colors.white70,
                          ),
                        ),
                        style: TextStyle(
                          color: (!passwordvalide)?Colors.red:Colors.white,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,
                        onFieldSubmitted: (v){
                          FocusScope.of(context).requestFocus(confirm_password_focus_node);
                          if(passwordController.text.length>=6){
                            passwordvalide = true;
                          }else{
                            passwordvalide = false;

                          }
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: confirmpasswordController,

                        focusNode: confirm_password_focus_node,
                        obscureText:true,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          focusColor: (!confirmpasswordvalide)?Colors.red:Colors.white,
                          labelText: 'Password confirmation',
                          labelStyle: TextStyle(
                              color: (!confirmpasswordvalide)?Colors.red:Colors.white
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (!confirmpasswordvalide)?Colors.red:Colors.white,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (!confirmpasswordvalide)?Colors.red:Colors.white54,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (!confirmpasswordvalide)?Colors.red:Colors.white,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                          suffixIcon: Icon(
                            Icons.vpn_key_rounded,
                            size: 15,
                            color: (!confirmpasswordvalide)?Colors.red:Colors.white70,
                          ),
                        ),
                        style: TextStyle(
                          color: (!confirmpasswordvalide)?Colors.red:Colors.white,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,
                        onFieldSubmitted: (v){
                          if(confirmpasswordController.text ==  passwordController.text){
                            confirmpasswordvalide = true;
                          }else{
                            confirmpasswordvalide = false;
                          }
                          FocusScope.of(context).requestFocus(main_focus_node);
                          pos_y= 1;
                          setState(() {

                          });
                        },
                      ),

                      Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: (){
                             setState(() {
                               pos_y = 1;
                               privacy = !privacy;
                             });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(

                                    height:40,
                                    decoration: BoxDecoration(
                                    ),
                                    child: Center(
                                      child: Container(
                                        height:25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: (!accept)?Colors.red: (pos_y == 1)? Colors.white : Colors.white38,width: 2)
                                        ),
                                        child: Icon( FontAwesomeIcons.check ,color:   (pos_y == 1)? (privacy)? Colors.white :Colors.transparent: (privacy)? Colors.white38 :Colors.transparent, size: 15,),
                                      ),
                                    )
                                ),
                                SizedBox(width: 10),
                                Center(
                                  child: Text(
                                    "I agree to the privacy policy",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:(!accept)?Colors.red: (pos_y == 1)? Colors.white :(pos_y == 1)? Colors.white : Colors.white38,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
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
                          setState(() {
                            pos_y=2;
                            _goToValidate();
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border:Border.all(color: (pos_y == 2)? Colors.white:Colors.deepOrangeAccent,width: 2),
                              color:Colors.deepOrangeAccent,
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
                                        borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(5),topLeft: Radius.circular(5))
                                    ),
                                    child: Icon( FontAwesomeIcons.signInAlt ,color:   Colors.white,)
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      (loading)?
                                      "Operation in progress ..."
                                          :
                                      "Create your account account !",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              padding:  EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Privacy Policy !",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color:(pos_y == 3)? Colors.white:Colors.white60
                                ),
                              )
                          ),
                        ],
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
  void _accept(){
    if(pos_y == 1){
        setState(() {
          privacy = !privacy;
          accept = true;
        });
    }
  }
  void _goToValidate() {
    if(pos_y == 2){

      if(checkEmail(usernameController.text)){
        emailvalide = true;
      }else{
        emailvalide = false;
      }
      if(nameController.text.length>=3){
        namevalide = true;
      }else{
        namevalide = false;
      }

      if(passwordController.text.length>=6){
        passwordvalide = true;
      }else{
        passwordvalide = false;

      }

      if(confirmpasswordController.text ==  passwordController.text){
        confirmpasswordvalide = true;
      }else{
        confirmpasswordvalide = false;
      }
      if(privacy ==  true){
        accept = true;
      }else{
        accept = false;
      }
      setState(() {

      });
      if(passwordvalide && emailvalide && accept && namevalide && confirmpasswordvalide){
        _register(usernameController.text.toString(),usernameController.text.toString(), passwordController.text.toString(), "https://lh3.googleusercontent.com/-XdUIqdMkCWA/AAAAAAAAAAI/AAAAAAAAAAA/4252rscbv5M/photo.jpg", nameController.text.toString(), "email");
      }

    }
  }
  bool checkEmail(String email){
    if(email.length<6)
      return false;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    return emailValid;
  }
}
