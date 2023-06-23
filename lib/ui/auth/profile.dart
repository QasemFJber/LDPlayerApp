import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/auth/edit.dart';
import 'package:flutter_app_tv/ui/auth/password.dart';
import 'package:flutter_app_tv/ui/auth/profile_item_widget.dart';
import 'package:flutter_app_tv/ui/auth/subscriptions.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:need_resume/need_resume.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ResumableState<Profile> {

  bool infos = false;
  bool? logged;
  bool? subscribe;
  String name = "";
  String type = "";
  Image image = Image.asset("assets/images/profile.jpg");

  String email = "";

  FocusNode main_focus_node = FocusNode();
  double pos_y = 0;
  double pos_x = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLogged();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(main_focus_node);
    });
  }

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    getLogged();


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(infos){
          setState(() {
            infos = false;
          });
          return false;
        }
        return true;
      },
      child: RawKeyboardListener(
        focusNode: main_focus_node,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid =rawKeyDownEvent.data as RawKeyEventDataAndroid;
            print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
            switch (rawKeyEventDataAndroid.keyCode) {
              case KEY_CENTER:
                if(infos)
                  break;
                _showInfos();
                _logout();
                _goToChangePassword();
                _goToEditProfile();
                _goToSubscriptions();
                break;
              case KEY_UP:
                if(infos)
                  break;
                if(pos_y > 0) {
                  pos_y --;
                }
                break;
              case KEY_DOWN:
                if(infos)
                  break;
                if(pos_y < 4) {
                  pos_y ++;
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
                if(logged == true)
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
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color:Colors.white.withOpacity(0.4),
                                              offset: Offset(0,0),
                                              blurRadius: 5
                                          ),
                                        ],
                                    ),
                                    height: 50,
                                    child: ClipRRect(
                                      child: image,
                                      borderRadius:  BorderRadius.circular(5)
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                      name.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900
                                      ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child:Container(
                              color: Colors.black.withOpacity(0.6),
                              child:  Stack(
                                children: [
                                  Visibility(
                                    visible: !infos,
                                    child: Column(
                                      children: [
                                        ProfileItemWidget(icon: Icons.person,title: "My Profile",isFocused: (pos_y == 0),subtitle: "My profile informations",action: (){
                                            setState(() {
                                              pos_y =0;
                                              _showInfos();
                                            });
                                        }),
                                        ProfileItemWidget(icon: Icons.edit,title: "Edit Profile",isFocused: (pos_y == 1),subtitle: "Edit profile informations",action: (){
                                          setState(() {
                                            pos_y =1;
                                            _goToEditProfile();
                                          });
                                        }),
                                        ProfileItemWidget(icon: Icons.star,title: "Subscriptions",isFocused: (pos_y == 2),subtitle: "My subscriptions history",action:(){
                                          setState(() {
                                            pos_y =2;
                                            _goToSubscriptions();
                                          });
                                        }),
                                        ProfileItemWidget(icon: Icons.lock,title: "Change password",isFocused: (pos_y == 3),subtitle: "Change my password",action: (){
                                          setState(() {
                                            pos_y =3;
                                            _goToChangePassword();
                                          });
                                        }),
                                        ProfileItemWidget(icon: Icons.logout,title: "Logout",isFocused: (pos_y == 4),subtitle: "Logout me from this device",action:(){
                                          setState(() {
                                            pos_y =4;
                                            _logout();
                                          });
                                        }),

                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: infos,
                                    child: Column(
                                      children: [
                                        ProfileItemWidget(icon: Icons.person,title: "Name",isFocused: false,subtitle: name, action: () {  },),
                                        ProfileItemWidget(icon: Icons.mail,title: "Email / Id ("+ type +")",isFocused: false,subtitle: email, action: () {  },),
                                        ProfileItemWidget(icon: (subscribe!)? Icons.star: Icons.star_border,title: "Subscriptions",isFocused: false,subtitle: (subscribe!)?" You are premium now":"you are not subscribed yet !", action: () {  },),
                                      ],
                                    ),
                                  ),
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
      ),
    );
  }

   getLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    logged =  prefs.getBool("LOGGED_USER");

    if(logged == true) {
      String? img = prefs.getString("IMAGE_USER");
      image = Image.network( img!);
      name =  prefs.getString("NAME_USER")!;
      email =  prefs.getString("USERNAME_USER")!;
      type =  prefs.getString("TYPE_USER")!;
      subscribe =  (prefs.getString("NEW_SUBSCRIBE_ENABLED") ==  "FALSE")? false:true;
      setState(() {

      });
    }else{
      logged = false;
      image = Image.asset("assets/images/profile.jpg");
    }
    setState(() {

    });
  }
  void  _logout(){
    if(pos_y == 4){
      logout();
    }
  }
  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

    Fluttertoast.showToast(
      msg: "You have logout in successfully !",
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    Navigator.pop(context);
  }
  void _showInfos() {
    if(pos_y == 0){
      setState(() {
        infos=true;
      });
    }
  }

  void _goToChangePassword() {
    if(pos_y == 3){
      push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Password(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void _goToSubscriptions() {
    if(pos_y == 2){
      push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Subscriptions(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void _goToEditProfile() {
    if(pos_y == 1){
      push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Edit(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }

}
