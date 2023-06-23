

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/ui/channel/channels.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/auth/login.dart';
import 'package:flutter_app_tv/ui/pages/contact.dart';
import 'package:flutter_app_tv/ui/pages/privacy.dart';
import 'package:flutter_app_tv/ui/setting/setting_subtitbles_widget.dart';
import 'package:flutter_app_tv/ui/channel/category_widget.dart';
import 'package:flutter_app_tv/ui/setting/setting_bg_widget.dart';
import 'package:flutter_app_tv/ui/setting/setting_color_widget.dart';
import 'package:flutter_app_tv/ui/setting/setting_size_widget.dart';
import 'package:flutter_app_tv/ui/setting/setting_widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

import 'package:http/http.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Settings extends StatefulWidget {


  Settings();

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _subtitle_size =33;
  int _subtitle_color =0;
  int _subtitle_background =0;





  FocusNode main_focus_node = FocusNode();
  double pos_y = 0;
  double pos_x = 0;

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSettings();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(main_focus_node);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: main_focus_node,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
          RawKeyDownEvent rawKeyDownEvent = event;
          RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data as RawKeyEventDataAndroid;
          print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
          switch (rawKeyEventDataAndroid.keyCode) {
            case KEY_CENTER:
              _goToPrivacyPolicy();
              _goToContactUs();
              break;
            case KEY_UP:
              if(pos_y > 0) {
                pos_y --;
              }
              break;
            case KEY_DOWN:
              if(pos_y < 5) {
                pos_y ++;
              }
              break;
            case KEY_LEFT:

              if(pos_y == 0){
                if(_subtitle_size > 5)
                  _subtitle_size --;

                prefs.setInt("subtitle_size", _subtitle_size);

              }
              if(pos_y == 1){
                if(_subtitle_color>0)
                  _subtitle_color --;
                else
                  _subtitle_color = 10;

                prefs.setInt("subtitle_color", _subtitle_color);
              }


              if(pos_y == 2){
                if(_subtitle_background>0)
                  _subtitle_background --;
                else
                  _subtitle_background = 10;
              }
              break;
            case KEY_RIGHT:

              if(pos_y == 0){
                if(_subtitle_size< 45)
                  _subtitle_size ++;

                prefs.setInt("subtitle_size", _subtitle_size);

              }
              if(pos_y == 1){
                if(_subtitle_color < 10)
                  _subtitle_color ++;
                else
                  _subtitle_color = 0;

                prefs.setInt("subtitle_color", _subtitle_color);

              }
              if(pos_y == 2){
                if(_subtitle_background < 11)
                  _subtitle_background ++;
                else
                  _subtitle_background = 0;

                prefs.setInt("subtitle_background", _subtitle_background);

              }
              break;
            default:
              break;
          }
          setState(() {

          });
        }
      },
      child: Scaffold(
          backgroundColor:  Theme.of(context).scaffoldBackgroundColor,

          body:Stack(
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
                    color: Colors.black54,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black87,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80.0,left: 10,bottom: 10),
                            child: Row(
                              children: [
                                Icon(Icons.settings,color: Colors.white70,size: 35),
                                SizedBox(width: 10),
                                Text(
                                  "Settings",
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
                        Expanded(
                          child:Container(
                            color: Colors.black.withOpacity(0.6),
                            child:  Column(
                              children: [
                                //SettingSubtitleWidget(icon: Icons.subtitles,title: "Subtitles",isFocused: (pos_y == 0),subtitle: "Movies and series subtitles",enabled: _subtitle_enabled),
                                SettingSizeWidget(icon: Icons.text_fields,title: "Subtitle size",isFocused: (pos_y == 0),subtitle: "Subtitle text size",size:_subtitle_size),
                                SettingColorWidget(icon: Icons.text_format,title: "Subtitle color",isFocused:  (pos_y == 1),subtitle: "Subtitle text color",color: _subtitle_color),
                                SettingBackgroundWidget(icon: Icons.format_color_fill,title: "Subtitle Background color",isFocused:  (pos_y == 2),subtitle: "Subtitle text background color",color: _subtitle_background),
                                SettingWidget(icon: Icons.lock,title: "Privacy Policy",isFocused: (pos_y == 3),subtitle: "Privacy policy / terms and conditions ",action:(){
                                  setState(() {
                                    pos_y = 3;
                                  });
                                  _goToPrivacyPolicy();
                                }),
                                SettingWidget(icon: Icons.email,title: "Contact us",isFocused: (pos_y == 4),subtitle: "support and report bugs",action:(){
                                  setState(() {
                                    pos_y = 4;
                                  });
                                  _goToContactUs();
                                }),
                                SettingWidget(icon: Icons.info,title: "Versions",isFocused: (pos_y == 5),subtitle: "2.3", action: (){}),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );

  }

 /* void _toggleSubtitles() {
    if(pos_y == 0 ){
      setState(() {
        _subtitle_enabled = !_subtitle_enabled;

      });
    }
  }*/


  void _goToPrivacyPolicy() {
    if(pos_y == 3 ){
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Privacy(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void _goToContactUs() {
    if(pos_y == 4 ){
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Contact(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }

  void initSettings() async{
    prefs = await SharedPreferences.getInstance();
    //_subtitle_enabled  =  prefs.getBool("subtitle_enabled");
    _subtitle_size =  prefs.getInt("subtitle_size")!;
    _subtitle_color =  prefs.getInt("subtitle_color")!;
    _subtitle_background =  prefs.getInt("subtitle_background")!;
    setState(() {

    });

  }
}
