import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/auth/login.dart';
import 'package:flutter_app_tv/ui/auth/register.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:need_resume/need_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import 'package:transparent_image/transparent_image.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends ResumableState<Auth> {
  FocusNode main_focus_node = FocusNode();

  int pos_y = 0;
  String tokenKey ="none";
  bool facebookloading =false;
  bool googleloading =false;
  bool? logged;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(main_focus_node);
       GoogleSignIn().signOut();

    });

  }

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    getLogged();

  }
  getLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    logged = prefs.getBool("LOGGED_USER");
    if(logged == true){
      Navigator.pop(context);
  }

  }

    _register(String? username,String? email,String? password,String? image,String? name,String? type) async{

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
            Fluttertoast.showToast(
              msg: "Operation has been cancelled !",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        }else{

          Fluttertoast.showToast(
            msg: "Operation has been cancelled !",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );

        }
      }
    }else{
      Fluttertoast.showToast(
        msg: "Operation has been cancelled !",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    setState(() {
      facebookloading = false;
      googleloading = false;
    });

  }
  Future<UserCredential> signInWithGoogle() async {
    setState(() {
      googleloading = true;
    });
    final FirebaseAuth _auth = FirebaseAuth.instance;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      assert(user.uid == currentUser?.uid);
      _register(currentUser?.uid, currentUser?.email, currentUser?.uid, currentUser?.photoURL, currentUser?.displayName, "google");
    }else{
      Fluttertoast.showToast(
        msg:"Operation has been cancelled !",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        facebookloading = false;
        googleloading = false;
      });
    }
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  Future<void> _Facebooklogin() async {
    setState(() {
      facebookloading = true;
    });
    final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {

      final userData = await FacebookAuth.instance.getUserData();

      _register(userData["id"],userData["email"], userData["id"], userData["picture"]["data"]["url"], userData["name"],"facebook");

    }else{
      Fluttertoast.showToast(
        msg:"Operation has been cancelled !"+result.message.toString(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      setState(() {
        facebookloading = false;
        googleloading = false;
      });
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
            RawKeyEventDataAndroid rawKeyEventDataAndroid =rawKeyDownEvent.data as RawKeyEventDataAndroid;
            print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
            if(facebookloading || googleloading)
              return;
            switch (rawKeyEventDataAndroid.keyCode) {

              case KEY_CENTER:
                _goToLogin();
                _goToRegister();
                _goToGoogle();
                _goToFacebook();
                break;
              case KEY_UP:
                if(pos_y  ==  0){
                  print("play sound");
                }else{
                  pos_y --;
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset( "assets/images/logo.png",height: 40,color: Colors.white)),
                      SizedBox(height: 40),
                      Text(
                        "Sign in now for free !",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          pos_y = 0;
                          setState(() {

                          });
                          _goToLogin();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border:Border.all(color: (pos_y == 0)? Colors.white: (facebookloading == true || googleloading == true)? Colors.deepPurple.withOpacity(0.2) : Colors.deepPurple,width: 2),
                            color:(facebookloading == true || googleloading == true)? Colors.deepPurple.withOpacity(0.2): Colors.deepPurple,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  height:40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(4),topLeft: Radius.circular(4))
                                  ),
                                  child: Icon( FontAwesomeIcons.envelope ,color: Colors.white)
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Sign in to your account !",
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
                      GestureDetector(
                        onTap: (){
                          pos_y = 1;
                          setState(() {

                          });
                          _goToGoogle();

                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border:Border.all(color: (pos_y == 1)? Colors.white:Colors.red,width: 2),
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (googleloading == true )?
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
                              ):
                              Container(
                                  height:40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(4),topLeft: Radius.circular(4))
                                  ),
                                  child: Icon( FontAwesomeIcons.google ,color: Colors.white)
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    (googleloading == true )?
                                    "Operation in progress  ...":
                                    "Sign in with google account !",
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
                      GestureDetector(
                        onTap: (){
                          pos_y = 2;
                          setState(() {

                          });
                          _goToFacebook();
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border:Border.all(color: (pos_y == 2)? Colors.white:Colors.indigo,width: 2),

                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(5),

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (facebookloading == true )?
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
                                ):
                                Container(
                                    height:40,
                                    width: 40,
                                    decoration: BoxDecoration(

                                        color: Colors.white10,
                                        borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(4),topLeft: Radius.circular(4))
                                    ),
                                    child: Icon( FontAwesomeIcons.facebookF ,color: Colors.white)
                                ) ,
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      (facebookloading == true )?
                                      "Operation in progress  ...":
                                      "Sign in with facebook account !"
                                          ,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          pos_y = 3;
                          setState(() {

                          });
                          _goToRegister();
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border:Border.all(color: (pos_y == 3)? Colors.white:(facebookloading == true || googleloading == true)?  Colors.deepOrangeAccent.withOpacity(0.1):Colors.deepOrangeAccent,width: 2),

                              color:(facebookloading == true || googleloading == true)?  Colors.deepOrangeAccent.withOpacity(0.1):Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(5),

                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height:40,
                                    width: 40,
                                    decoration: BoxDecoration(

                                        color: Colors.white10,
                                        borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(4),topLeft: Radius.circular(4))
                                    ),
                                    child: Icon( FontAwesomeIcons.userCheck ,color: Colors.white)
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "Create your account account !",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
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

  void _goToRegister() {
    if(pos_y == 3){
      push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Register(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void _goToLogin() {
    if(pos_y == 0){
      push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Login(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void _goToGoogle() {
    if(pos_y == 1){
      signInWithGoogle();
    }
  }
  void _goToFacebook() {
    if(pos_y == 2){
      _Facebooklogin();
    }
  }
}
