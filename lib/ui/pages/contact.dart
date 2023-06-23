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

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  FocusNode main_focus_node = FocusNode();
  FocusNode email_focus_node= FocusNode();
  FocusNode name_focus_node= FocusNode();
  FocusNode message_focus_node= FocusNode();
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  bool emailValide = true;
  bool nameValide = true;
  bool messageValide = true;
  bool loading = false;
  String _message_error = "";
  bool _visibile_error =false;
  int pos_y = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(email_focus_node);
    });
  }
  Future<String>  _changeContact() async{
    setState(() {
      loading = true;
      _visibile_error = false;

    });
    var response;
    var data ={
      "email":emailController.text,
      "name":nameController.text,
      "message":messageController.text,
    };
    response = await apiRest.sendMessage(data);
    print(response.body);
    if (response != null) {
      if (response.statusCode == 200) {
        var jsonData = convert.jsonDecode(response.body);
        if(jsonData["code"].toString() == "200"){




            Fluttertoast.showToast(
              msg: "Your message has been sent successfully !",
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
    return "done";
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
                  FocusScope.of(context).requestFocus(email_focus_node);
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
                        "Contact us & report bugs",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                          controller: emailController,
                          focusNode: email_focus_node,
                          textInputAction: TextInputAction.next,

                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            focusColor: Colors.white,
                            labelText: 'E-mail',
                            labelStyle: TextStyle(
                                color: (emailValide)?Colors.white:Colors.red
                            ),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (emailValide)?Colors.white:Colors.red,width: 1)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (emailValide)?Colors.white54:Colors.red,width: 1)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (emailValide)?Colors.white:Colors.red,width: 1)),
                            contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                            suffixIcon: Icon(
                              Icons.mail,
                              size: 15,
                              color: (emailValide)?Colors.white70:Colors.red,
                            ),
                          ),
                          style: TextStyle(
                            color: (emailValide)?Colors.white:Colors.red,
                          ),
                          maxLines: 1,
                          minLines: 1,
                          scrollPadding: EdgeInsets.zero,
                          cursorColor: Colors.white,
                          onFieldSubmitted: (v){
                            if(emailController.text.length>=6){
                              emailValide = true;
                            }else{
                              emailValide = false;
                            }

                            setState(() {

                            });
                            FocusScope.of(context).requestFocus(name_focus_node);
                          }
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: nameController,
                        focusNode: name_focus_node,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          labelText: 'Full name',
                          labelStyle: TextStyle(
                              color: (nameValide)?Colors.white:Colors.red
                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (nameValide)?Colors.white:Colors.red,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (nameValide)?Colors.white54:Colors.red,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (nameValide)?Colors.white:Colors.red,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                          suffixIcon: Icon(
                            Icons.text_fields,
                            size: 15,
                            color: (nameValide)?Colors.white70:Colors.red,
                          ),
                        ),
                        style: TextStyle(
                          color: (nameValide)?Colors.white70:Colors.red,
                        ),
                        maxLines: 1,
                        minLines: 1,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,

                        onFieldSubmitted: (v){

                          if(nameController.text.length>=3){
                            nameValide = true;
                          }else{
                            nameValide = false;

                          }

                          FocusScope.of(context).requestFocus(message_focus_node);
                          setState(() {

                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: messageController,
                        focusNode: message_focus_node,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          labelText: 'Message',
                          labelStyle: TextStyle(
                              color: (messageValide)?Colors.white:Colors.red,

                          ),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (messageValide)?Colors.white:Colors.red,width: 1)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (messageValide)?Colors.white54:Colors.red,width: 1)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),borderSide: BorderSide(color: (messageValide)?Colors.white:Colors.red,width: 1)),
                          contentPadding: new EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                          suffixIcon: Icon(
                            Icons.message,
                            size: 15,
                            color: (messageValide)?Colors.white70:Colors.red,
                          ),
                        ),
                        style: TextStyle(
                          color: (messageValide)?Colors.white70:Colors.red,
                        ),
                        maxLines: 5,
                        minLines: 5,
                        scrollPadding: EdgeInsets.zero,
                        cursorColor: Colors.white,

                        onFieldSubmitted: (v){

                          if(messageController.text.length>=6){
                            messageValide = true;
                          }else{
                            messageValide = false;

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
                                  child: Icon( FontAwesomeIcons.paperPlane ,color: Colors.white)
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    (loading)?
                                    "Operation in progress ..."
                                        :
                                    "Send message  !",
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

      if(checkEmail(emailController.text)){
        emailValide = true;
      }else{
        emailValide = false;
      }
      if(nameController.text.length>=3){
        nameValide = true;
      }else{
        nameValide = false;

      }
      if(messageController.text.length>=6){
        messageValide = true;
      }else{
        messageValide = false;

      }
      setState(() {

      });

      if(nameValide && emailValide && messageValide){
        _changeContact();
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
