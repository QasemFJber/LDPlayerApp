
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_config.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/model/genre.dart';
import 'package:flutter_app_tv/model/poster.dart';
import 'package:flutter_app_tv/model/channel.dart' as model;
import 'package:flutter_app_tv/model/slide.dart';
import 'package:flutter_app_tv/ui/auth/auth.dart';
import 'package:flutter_app_tv/ui/auth/profile.dart';
import 'package:flutter_app_tv/ui/channel/channel_detail.dart';
import 'package:flutter_app_tv/ui/channel/channels.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/ui/home/home_loading_widget.dart';
import 'package:flutter_app_tv/ui/movie/movie.dart';
import 'package:flutter_app_tv/ui/movie/movie_short_detail.dart';
import 'package:flutter_app_tv/ui/movie/movies.dart' as mmm;
import 'package:flutter_app_tv/ui/search/search.dart';
import 'package:flutter_app_tv/ui/serie/serie.dart';
import 'package:flutter_app_tv/ui/serie/series.dart';
import 'package:flutter_app_tv/ui/setting/settings.dart';
import 'package:flutter_app_tv/ui/channel/channels_widget.dart';
import 'package:flutter_app_tv/ui/movie/movies_widget.dart';
import 'package:flutter_app_tv/widget/navigation_widget.dart';
import 'package:flutter_app_tv/widget/slide_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:need_resume/need_resume.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

/// A [StatelessWidget] which demonstrates
/// how to consume and interact with a [CounterBloc].
class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}




class _MyListState extends ResumableState<MyList> {


  List<Genre> genres = [];
  List<model.Channel> channels = [];


  int postx = 5;
  int posty = -2;
  ItemScrollController _scrollController = ItemScrollController();
  List<ItemScrollController> _scrollControllers = [];
  List<int> _position_x_line_saver = [];
  List<int> _counts_x_line_saver = [];
  FocusNode home_focus_node = FocusNode();
  Poster? selected_poster;
  model.Channel? selected_channel;

  List<Poster> postersList = [];
  int _focused_channel =0 ;


  bool _visibile_loading = false;
  bool _visibile_error = false;
  bool _visibile_success = false;
  bool? logged;
  Image image = Image.asset("assets/images/profile.jpg");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLogged();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(home_focus_node);
      _getList();

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

    logged = await prefs.getBool("LOGGED_USER");

    if(logged == true) {
      String? img = await prefs.getString("IMAGE_USER");
      image = Image.network(img!);
    }else{
      logged = false;
      image = Image.asset("assets/images/profile.jpg");
    }
    setState(() {
      print(logged);
    });

  }

  void _getList()  async{
    if(logged == true ){
    _counts_x_line_saver.clear();
    _position_x_line_saver.clear();
    _scrollControllers.clear();
    _showLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id_user =  prefs.getInt("ID_USER");
    String? key_user =  prefs.getString("TOKEN_USER");
    var response =await apiRest.myList(id_user!, key_user!);
    if(response == null){
      _showTryAgain();
    }else{
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);

        if(jsonData["channels"] != null){
          for(Map<String,dynamic> channel_map  in jsonData["channels"]){
            model.Channel channel = model.Channel.fromJson(channel_map);
            channels.add(channel);
            selected_channel =channel;
          }
          if(channels.length>0) {
            ItemScrollController controller = new ItemScrollController();
            _scrollControllers.add(controller);
            _position_x_line_saver.add(0);
            _counts_x_line_saver.add(channels.length);

            Genre genre = new Genre(id: -3, title: "");
            genres.add(genre);
          }

        }
        if(jsonData["posters"] != null){

            for(Map<String,dynamic> poster_map  in jsonData["posters"]){
              Poster poster = Poster.fromJson(poster_map);
              postersList.add(poster);
              if(selected_channel == null){
                selected_poster  = poster;
              }
            }

            if(postersList.length>0){
                Genre genre = Genre(id: 0,title: "Movies and TV Serie",posters: postersList);

                genres.add(genre);
                ItemScrollController controller = new ItemScrollController();
                _scrollControllers.add(controller);
                _position_x_line_saver.add(0);
                _counts_x_line_saver.add(genre.posters!.length);
            }
        }

        _showData();

      } else {
        _showTryAgain();
      }
    }
    setState(() {

    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body:RawKeyboardListener(
        focusNode: home_focus_node,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
            RawKeyDownEvent rawKeyDownEvent = event;
            RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data as RawKeyEventDataAndroid;
            switch (rawKeyEventDataAndroid.keyCode) {
              case KEY_CENTER:

                _goToSearch();
                _goToHome();
                _goToMovies();
                _goToSeries();
                _goToChannels();
                _goToSettings();
                _goToProfile();

                _tryAgain();
                _goToMovieDetail();
                _goToChannelDetail();
                break;
              case KEY_UP:
                if(_visibile_loading){
                  print("playing sound ");
                  break;
                }
                if(_visibile_error){
                  if(posty ==  -2){
                    print("playing sound ");
                  }else if(posty == 0){
                    posty--;
                    postx=0;
                  }
                  break;
                }
                if(posty ==  -2){
                  print("playing sound ");
                }else if(posty == -1){
                  posty--;
                  postx=1;
                }else if(posty == 0){
                  posty = -2;
                  postx=0;
                }
                else{
                  posty--;
                  postx = _position_x_line_saver[posty];
                  _scrollToIndexXY(postx,posty);
                }
                break;
              case KEY_DOWN:
                if(channels.length == 0 && postersList.length == 0){
                  print("playing sound ");
                  break;
                }
                if(_visibile_error){
                  if(posty < -1)
                    posty++;
                  else
                    print("playing sound ");
                  break;
                }
                if(_visibile_loading){
                  print("playing sound ");
                  break;
                }
                if(posty == -2){
                  posty = 0;
                  postx = _position_x_line_saver[posty];
                  _scrollToIndexXY(postx,posty);
                  break;
                }
                if(genres.length-1==posty){
                  print("playing sound ");
                }else{
                  posty++;
                  if(posty >= 0){
                    postx = _position_x_line_saver[posty];
                    _scrollToIndexXY(postx,posty);
                  }

                }
                break;
              case KEY_LEFT:

                if(_visibile_error){
                  if(posty < -1)
                    posty++;
                  else
                    print("playing sound ");
                  break;
                }
                if(posty == -2){
                  if(postx == 0){
                    print("playing sound ");
                  }else{
                    postx--;
                  }
                }else if (posty == -1){

                }else{
                  if(postx == 0){
                    print("playing sound ");
                  }else{
                    postx--;
                    _position_x_line_saver[posty]=postx;
                    _scrollToIndexXY(postx,posty);
                  }
                }
                break;
              case KEY_RIGHT:
                switch(posty){
                  case -1:
                    if(_visibile_loading || _visibile_error){
                      print("playing sound ");
                      break;
                    }
                    break;
                  case -2:
                    if(postx == 7)
                      print("playing sound ");
                    else
                      postx++;
                    break;
                  default:
                    if(_counts_x_line_saver[posty]-1 == postx){
                      print("playing sound ");
                    }else{
                      postx++;
                      _position_x_line_saver[posty]=postx;
                      _scrollToIndexXY(postx,posty);
                    }
                    break;
                }

                break;
              default:
                break;
            }


            if(channels.length > 0 && posty == 0){
              selected_poster =null;
              selected_channel =  channels[postx];
            }

            int poster_pos = 1;
            if(channels.length == 0)
              poster_pos=0;

            if(postersList.length > 0 && posty == poster_pos){
              selected_channel =null;
              selected_poster =  postersList[postx];
            }


            setState(() {

            });
          }
        },
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              left: MediaQuery.of(context).size.width/4,
              bottom: MediaQuery.of(context).size.height/4,
              child:getBackgroundImage(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.black,Colors.black,Colors.black54,Colors.black54,Colors.black54],
                      )
                  )
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height/3),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black,Colors.black, Colors.transparent, Colors.transparent],
                      )
                  )
              ),
            ),
            Positioned(
              top:  10,
              left: 50,
              right: 50,
              child: AnimatedOpacity(
                opacity: (posty < 0)? 0 : 1,
                duration: Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      posty = -1;
                    });
                  },
                  child: Container(
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            if(_visibile_success && postersList.length == 0 && channels.length == 0)
              _emptyWidget(),
            if(_visibile_success && (selected_poster!= null || selected_channel != null))
                AnimatedPositioned(
                    top: (posty < 0)? 70 : 40,
                    left: 0,
                    right: 0,
                    duration: Duration(milliseconds: 200),
                    child: MovieShortDetailWidget(channel :  selected_channel,poster:selected_poster)
                ),
            if(_visibile_loading)
              HomeLoadingWidget(),
            if(_visibile_error)
              _tryAgainWidget(),
            if(_visibile_success)
              AnimatedPositioned(
                bottom: 0,
                left: 0,
                right: 0,
                duration: Duration(milliseconds: 200),
                height: (posty < 0)?(MediaQuery.of(context).size.height/2) :(MediaQuery.of(context).size.height/2)+0,
                child: Container(
                  height: (posty < 0)?(MediaQuery.of(context).size.height/2):(MediaQuery.of(context).size.height/2)+0,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),   // From this behaviour you can change the behaviour
                    child: ScrollablePositionedList.builder(
                      itemCount: genres.length,
                      scrollDirection: Axis.vertical,
                      itemScrollController: _scrollController,
                      itemBuilder: (context, jndex) {
                        if(genres[jndex].id == -3){
                          return ChannelsWidget(jndex:jndex,postx: postx,posty: posty,scrollController: _scrollControllers[jndex],size: 15,title: "TV Channels",channels: channels);
                        }else{
                          return MoviesWidget(jndex:jndex,posty: posty,postx: postx,scrollController: _scrollControllers[jndex],title: genres[jndex].title,posters : genres[jndex].posters);
                        }
                      },
                    ),
                  ),
                ),
              ),
            NavigationWidget(postx:postx,posty:posty,selectedItem : 5,image : image, logged : logged),
          ],
        ),
      ),
    );
  }
  void  _goToMovies(){
    if(posty == -2 && postx == 2){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => mmm.Movies(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }

  void  _goToHome(){
    if(posty == -2 && postx == 1){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Home(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
      FocusScope.of(context).requestFocus(null);
    }
  }
  void  _logout(){
    if(posty == -2 && postx == 0){
      logout();
      print("logout");
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
  }
  void  _goToSearch(){
    if(posty == -2 && postx == 0){
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Search(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
      FocusScope.of(context).requestFocus(null);
    }
  }


  void  _goToProfile(){

    if(posty == -2 && postx == 7){
      if(logged == true){
        push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Profile(),
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
  void  _goToSeries(){
    if(posty == -2 && postx == 3){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Series(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void  _goToChannels(){
    if(posty == -2 && postx == 4){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Channels(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void  _goToSettings(){
    if(posty == -2 && postx == 6){
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Settings(),
          transitionDuration: Duration(seconds: 0),
        ),
      );
      FocusScope.of(context).requestFocus(null);
    }
  }
  void _goToMovieDetail() {
    if(posty >= 0 ){
      if(genres[posty] != null){
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => (genres[posty].posters![postx].type == "serie")?Serie(serie:genres[posty].posters![postx]):Movie(movie:genres[posty].posters![postx]),
            transitionDuration: Duration(seconds: 0),
          ),
        );
        FocusScope.of(context).requestFocus(null);
      }
    }
  }
  void _goToChannelDetail() {
    if(posty == 0 ){
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => ChannelDetail(channel:channels[postx]),
          transitionDuration: Duration(seconds: 0),
        ),
      );
      FocusScope.of(context).requestFocus(null);
    }
  }

  Future _scrollToIndexXY(int x,int y) async {
    if(_scrollControllers.length > 0)
      _scrollControllers[y].scrollTo(index: x,duration: Duration(milliseconds: 500),alignment: 0.04,curve: Curves.fastOutSlowIn);

    _scrollController.scrollTo(index: y,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
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
  void _tryAgain(){
    if(_visibile_error && posty == -1){
      _getList();
    }
  }
  Widget _tryAgainWidget(){
    return Positioned(
      bottom: 0,
      left: 45,
      right: 45,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.height -70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text("Something wrong !",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Please check your internet connexion and try again  !",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: (){
                setState(() {
                  posty = - 1;
                  Future.delayed(Duration(milliseconds: 100),(){
                    _tryAgain();
                    posty = - 2;
                  });
                });
              },
              child: Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 40,
                  width: 250,
                  decoration: BoxDecoration(
                    border:Border.all(color: Colors.white54,width: 1),
                    color:(_visibile_error && posty == -1)? Colors.white: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height:40,
                          width: 40,
                          decoration: BoxDecoration(
                            color:(_visibile_error && posty == -1)?Colors.black: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon( Icons.refresh ,color:(_visibile_error && posty == -1)?Colors.white: Colors.black,)
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Try Again",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color:(_visibile_error && posty == -1)?Colors.black: Colors.white,
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
    );
  }
  Widget _emptyWidget(){
    return Positioned(
      bottom: 0,
      left: 45,
      right: 45,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.height -70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined,
              color: Colors.white,
              size: 150,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 5),
                Text("Empty list,nothing here !",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Please add some content to your list then back !",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget getBackgroundImage() {
      if(selected_channel == null && selected_poster == null)
        return Container(color: Colors.black);

      return  CachedNetworkImage(imageUrl:(selected_channel!= null)? selected_channel!.image:selected_poster!.cover,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,fadeInDuration: Duration(seconds: 1));
  }
}


class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}