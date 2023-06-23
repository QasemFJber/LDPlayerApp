

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/model/genre.dart';
import 'package:flutter_app_tv/model/poster.dart';
import 'package:flutter_app_tv/ui/auth/auth.dart';
import 'package:flutter_app_tv/ui/auth/profile.dart';
import 'package:flutter_app_tv/ui/channel/channels.dart';
import 'package:flutter_app_tv/ui/dialogs/genres_dialog.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/home/mylist.dart';
import 'package:flutter_app_tv/ui/movie/movie.dart';
import 'package:flutter_app_tv/ui/movie/movie_loading_widget.dart';
import 'package:flutter_app_tv/ui/movie/movie_widget.dart';
import 'package:flutter_app_tv/ui/movie/movies.dart';
import 'package:flutter_app_tv/ui/search/search.dart';
import 'package:flutter_app_tv/ui/serie/serie.dart';
import 'package:flutter_app_tv/ui/serie/series.dart';
import 'package:flutter_app_tv/ui/setting/settings.dart';

import 'package:flutter_app_tv/ui/movie/movie_short_detail_mini.dart';

import 'package:flutter_app_tv/widget/navigation_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:need_resume/need_resume.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';


/// A [StatelessWidget] which demonstrates
/// how to consume and interact with a [CounterBloc].
class Series extends StatefulWidget {
  @override
  _SeriesState createState() => _SeriesState();
}





class _SeriesState extends ResumableState<Series> {
  int postx = 3;
  int posty = -2;


  List<String> order = [
    "created",
    "views",
    "rating",
    "imdb",
    "title",
    "year",
  ];

  List<Genre> genres = [];
  List<Poster> series = [];

  int page = 0;

  int selected_sort = 1;

  int _focused_poster =0 ;
  int _focused_genre =0 ;
  int _selected_genre =0 ;
  ItemScrollController _scrollController = ItemScrollController();
  ItemScrollController _genresScrollController = ItemScrollController();

  List<ItemScrollController> _scrollControllers = [];
  List<int> _position_x_line_saver = [];
  List<int> _counts_x_line_saver = [];
  FocusNode home_focus_node = FocusNode();


  bool _visibile_genres_dialog = false;
  bool _visibile_loading = false;
  bool _visibile_error = false;
  bool _visibile_success = false;
  bool? logged;
  Image image = Image.asset("assets/images/profile.jpg");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(home_focus_node);
      _getGenres();
      _getList();

      getLogged();
    });


  }

  @override
  void onResume() {
    // TODO: implement onResume
    super.onResume();
    getLogged();

  }
  Future<String> getLogged() async {
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
    return "done";
  }
  void _getGenres()  async{
    genres.clear();
    Genre genre = Genre(id: 0,title: "All genres");
    genres.add(genre);
    var response =await apiRest.getGenres();
    if(response != null){
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        for(Map<String,dynamic> i in jsonData){
          Genre genre = Genre.fromJson(i);
          genres.add(genre);
        }
      }
    }
    _scrollControllers.clear();
    for(int jndex = 0;jndex < ((series.length/8).ceil());jndex++){
      int items_line_count = (series.length -  ((jndex+1) * 8) > 0)? 8:  (series.length -  (jndex * 8)).abs();

      ItemScrollController controller =  new ItemScrollController();
      _scrollControllers.add(controller);
      _position_x_line_saver.add(0);
      _counts_x_line_saver.add(items_line_count);
    }
  }
  void _getList()  async{
    series.clear();
    page =0;
    _showLoading();
    var response =await apiRest.getSeriesByFiltres(genres[_selected_genre].id, order[selected_sort -1],page);
    if(response == null){
      _showTryAgain();
    }else{
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        for(Map<String,dynamic> i in jsonData){
          Poster poster = Poster.fromJson(i);
          series.add(poster);
        }
        _showData();
        page++;
      } else {
        _showTryAgain();
      }
    }
    _scrollControllers.clear();
    for(int jndex = 0;jndex < ((series.length/8).ceil());jndex++){
      int items_line_count = (series.length -  ((jndex+1) * 8) > 0)? 8:  (series.length -  (jndex * 8)).abs();

      ItemScrollController controller =  new ItemScrollController();
      _scrollControllers.add(controller);
      _position_x_line_saver.add(0);
      _counts_x_line_saver.add(items_line_count);
    }
  }

  void _loadMore()  async{

    var response =await apiRest.getSeriesByFiltres(genres[_selected_genre].id, order[selected_sort -1],page);
    if(response != null){
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        for(Map<String,dynamic> i in jsonData){
          Poster poster = Poster.fromJson(i);
          series.add(poster);
        }
        page++;
      }
    }
    _scrollControllers.clear();
    for(int jndex = 0;jndex < ((series.length/8).ceil());jndex++){
      int items_line_count = (series.length -  ((jndex+1) * 8) > 0)? 8:  (series.length -  (jndex * 8)).abs();

      ItemScrollController controller =  new ItemScrollController();
      _scrollControllers.add(controller);
      _position_x_line_saver.add(0);
      _counts_x_line_saver.add(items_line_count);
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{

        if(_visibile_genres_dialog){
          setState(() {
            _visibile_genres_dialog = false;
          });

          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body:RawKeyboardListener(
          focusNode: home_focus_node,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
              RawKeyDownEvent rawKeyDownEvent = event;
              RawKeyEventDataAndroid rawKeyEventDataAndroid = rawKeyDownEvent.data  as RawKeyEventDataAndroid;
              print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
              switch (rawKeyEventDataAndroid.keyCode) {
                case KEY_CENTER:
                  _selectFilter();

                  _goToSearch();
                  _goToHome();
                  _goToMovies();
                  _goToChannels();
                  _goToMyList();
                  _goToSettings();
                  _goToProfile();

                  _goToSerieDetail();
                  _tryAgain();
                  if(_visibile_genres_dialog == true) {
                    _selectedGenre();
                  }else{
                    _showGenresDialog();
                  }
                  break;
                case KEY_UP:
                  if(_visibile_loading){
                    print("playing sound ");
                    break;
                  }
                  if(_visibile_error){
                    if(posty ==  -2){
                      print("playing sound ");
                    }else if(posty == -1){
                      print("go to menu");
                      posty--;
                      postx=0;
                    }
                    break;
                  }
                  if(_visibile_genres_dialog){
                    (_focused_genre  == 0 )?  print("play sound") : _focused_genre--;
                    break;
                  }
                  if(posty ==  -2){
                    print("playing sound ");
                  }else if(posty == -1){
                    print("go to menu");
                    posty--;
                    postx=3;
                  }else if(posty == 0){
                    print("go to slide");
                    posty--;
                    postx=0;
                  }else{
                    posty--;
                    _scrollToIndexXY(postx,posty);
                    _focused_poster =  ((posty * 8) + postx);
                  }
                  break;
                case KEY_DOWN:
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
                  if(_visibile_genres_dialog){
                    (_focused_genre  == genres.length -1 )? print("play sound") : _focused_genre++;
                    break;
                  }
                  if((series.length/8).ceil()-1==posty){
                    print("playing sound ");
                  }else{
                    posty++;
                    if(posty >= 0){
                      if(postx> (_counts_x_line_saver[posty] - 1)){
                        postx = _counts_x_line_saver[posty] -1;
                      }
                      _scrollToIndexXY(postx,posty);
                      _focused_poster =  ((posty * 8) + postx);
                    }else{
                      postx= 0;
                    }
                    if(posty == (series.length/8).ceil()-3){
                      _loadMore();
                    }
                  }
                  break;
                case KEY_LEFT:
                  if(_visibile_genres_dialog){
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
                    if(_visibile_loading || _visibile_error){
                      print("playing sound ");
                      break;
                    }
                    (postx == 0)? print("playing sound "): postx --;
                  }else{
                    if(_visibile_loading || _visibile_error){
                      print("playing sound ");
                      break;
                    }
                    if(postx == 0){
                      print("playing sound ");
                    }else{
                      postx--;
                      _scrollToIndexXY(postx,posty);
                    }
                    _focused_poster =  ((posty * 8) + postx);

                  }
                  break;
                case KEY_RIGHT:
                  if(_visibile_genres_dialog) {
                    print("playing sound ");
                    break;
                  }
                  switch(posty){
                    case -1:
                      if(_visibile_loading || _visibile_error){
                        print("playing sound ");
                        break;
                      }
                      (postx == 6)? print("playing sound "): postx ++;
                      break;
                    case -2:
                      if(postx == 7)
                        print("playing sound ");
                      else
                        postx++;
                      break;
                    default:
                      if(_visibile_loading || _visibile_error){
                        print("playing sound ");
                        break;
                      }
                      if(_counts_x_line_saver[posty]-1 == postx){
                        print("playing sound ");
                      }else{
                        postx++;
                        _scrollToIndexXY(postx,posty);
                      }
                      _focused_poster =  ((posty * 8) + postx);

                      break;
                  }


                  break;
                default:
                  break;
              }
              print("_focused_poster ${_focused_poster}");

              setState(() {

              });
              if(_visibile_genres_dialog && _genresScrollController!= null){
                _genresScrollController.scrollTo(index: _focused_genre,alignment: 0.43,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
              }
            }
          },
          child: Stack(
            children: [
              if(!series.isEmpty)
              Positioned(
                  right: 0,
                  top: 0,
                  left: MediaQuery.of(context).size.width/4,
                  bottom: MediaQuery.of(context).size.height/4,
                  child:CachedNetworkImage(imageUrl:series[_focused_poster].cover,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,fadeInDuration: Duration(seconds: 1))
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
              NavigationWidget(postx:postx,posty:posty,selectedItem : 3,image : image, logged : logged),
              if(_visibile_loading )
                MovieLoadingWidget(),
              if(_visibile_error )
                _tryAgainWidget(),
              if(series.length>0 && !_visibile_loading && !_visibile_error)
                AnimatedPositioned(
                    top: (posty < 0)? 70 : 40,
                    left: 0,
                    right: 0,
                    duration: Duration(milliseconds: 200),
                    child: MovieShortDetailMiniWidget(movie :  series[_focused_poster])
                ),
              Positioned(
                top:  10,
                left: 45,
                right: 45,
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
              if(_visibile_success)
                AnimatedPositioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  duration: Duration(milliseconds: 200),
                  height: (posty < 0)?(MediaQuery.of(context).size.height/2) + 20:(MediaQuery.of(context).size.height/2)+50,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 45),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           GestureDetector(
                             onTap: (){
                               setState(() {
                                 posty = -1;
                                 postx =0;
                                 Future.delayed(Duration(milliseconds: 50),(){
                                   _showGenresDialog();
                                 });
                               });
                             },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                margin: EdgeInsets.symmetric(vertical: 7),
                                height: 50,
                                child: Row(
                                  children: [
                                    Text(
                                      genres[_selected_genre].title,
                                      style: TextStyle(
                                          color: (posty == -1 && postx == 0)? Colors.black:Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: (posty == -1 && postx == 0)? Colors.black:Colors.white70,
                                      size: 30,
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: (posty == -1 && postx == 0)? Colors.white:Colors.transparent,
                                    border: Border.all(color: Colors.white70,width: 2),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: (posty == -1 && postx >0)? 1 :0.8,
                              duration: Duration(milliseconds: 250),
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(vertical: 7),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white,width: 2),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          posty = -1;
                                          postx =1;
                                          Future.delayed(Duration(milliseconds: 50),(){
                                            _selectFilter();
                                          });
                                        });

                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        height: 50,
                                        color: ((posty == -1 && postx == 1) || selected_sort == 1)? Colors.white:Colors.transparent,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              color: ((posty == -1 && postx == 1) || selected_sort == 1)? Colors.black:Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Newest",
                                              style: TextStyle(
                                                  color: ((posty == -1 && postx == 1) || selected_sort == 1)? Colors.black:Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          posty = -1;
                                          postx =2;
                                          Future.delayed(Duration(milliseconds: 50),(){
                                            _selectFilter();
                                          });
                                        });

                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        height: 50,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.remove_red_eye,
                                              color: ((posty == -1 && postx == 2) || selected_sort == 2)? Colors.black:Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Views",
                                              style: TextStyle(
                                                  color: ((posty == -1 && postx == 2) || selected_sort == 2)? Colors.black:Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(color: Colors.white,width: 1)),
                                          color: ((posty == -1 && postx == 2) || selected_sort == 2)? Colors.white:Colors.transparent,

                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          posty = -1;
                                          postx =3;
                                          Future.delayed(Duration(milliseconds: 50),(){
                                            _selectFilter();
                                          });
                                        });

                                      },
                                      child: Container(
                                        height: 50,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star_half,
                                              color: ((posty == -1 && postx == 3) || selected_sort == 3)? Colors.black:Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Rating",
                                              style: TextStyle(
                                                  color:((posty == -1 && postx == 3) || selected_sort == 3)? Colors.black:Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),

                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(color: Colors.white,width: 1)),
                                          color: ((posty == -1 && postx == 3) || selected_sort == 3)? Colors.white:Colors.transparent,

                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          posty = -1;
                                          postx =4;
                                          Future.delayed(Duration(milliseconds: 50),(){
                                            _selectFilter();
                                          });
                                        });

                                      },
                                      child: Container(
                                        height: 50,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.imdb,
                                              color: ((posty == -1 && postx == 4) || selected_sort == 4)? Colors.black:Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Imdb Rating",
                                              style: TextStyle(
                                                  color: ((posty == -1 && postx == 4) || selected_sort == 4)? Colors.black:Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),

                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(color: Colors.white,width: 1)),
                                          color: ((posty == -1 && postx == 4) || selected_sort == 4)? Colors.white:Colors.transparent,

                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          posty = -1;
                                          postx =5;
                                          Future.delayed(Duration(milliseconds: 50),(){
                                            _selectFilter();
                                          });
                                        });

                                      },
                                      child: Container(
                                        height: 50,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.text_fields,
                                              color: ((posty == -1 && postx == 5) || selected_sort == 5)? Colors.black:Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Title",
                                              style: TextStyle(
                                                  color: ((posty == -1 && postx == 5) || selected_sort == 5)? Colors.black:Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),

                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(color: Colors.white,width: 1)),
                                          color: ((posty == -1 && postx == 5) || selected_sort == 5)? Colors.white:Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          posty = -1;
                                          postx =6;
                                          Future.delayed(Duration(milliseconds: 50),(){
                                            _selectFilter();
                                          });
                                        });

                                      },
                                      child: Container(
                                        height: 50,
                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              color: ((posty == -1 && postx == 6) || selected_sort == 6)? Colors.black:Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "Year",
                                              style: TextStyle(
                                                  color: ((posty == -1 && postx == 6) || selected_sort == 6)? Colors.black:Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(left: BorderSide(color: Colors.white,width: 1)),
                                          color: ((posty == -1 && postx == 6) || selected_sort == 6)? Colors.white:Colors.transparent,

                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ScrollConfiguration(
                            behavior: MyBehavior(),   // From this behaviour you can change the behaviour
                            child: ScrollablePositionedList.builder(
                              itemCount: (series.length / 8).ceil(),
                              scrollDirection: Axis.vertical,
                              itemScrollController: _scrollController,
                              itemBuilder: (context, jndex) {
                                int items_line_count = (series.length -  ((jndex+1) * 8) > 0)? 8:  (series.length -  (jndex * 8)).abs();
                                return _seriesLineGridWidget(jndex,items_line_count);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              GenresDialog(genresScrollController: _genresScrollController,visibile: _visibile_genres_dialog,genresList: genres,focused_genre: _focused_genre,selected_genre:_selected_genre,close:closeGenreDialog,select:selectGenre),
            ],
          ),
        ),
      ),
    );
  }

  Future _scrollToIndexXY(int x,int y) async {

    try{
      _scrollControllers[y].scrollTo(index: x,duration: Duration(milliseconds: 500),alignment: 0.04,curve: Curves.fastOutSlowIn);
    }catch(ex){

    }
    _scrollController.scrollTo(index: y,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
  }

  void _selectFilter() {
    if(posty == -1 && postx > 0 && postx <7){
      setState(() {
        selected_sort = postx;
      });
      _getList();
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
  void  _goToMyList(){
    if(posty == -2 && postx == 5){
      if(logged == true){
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => MyList(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
        FocusScope.of(context).requestFocus(null);
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
  void  _goToMovies(){
    if(posty == -2 && postx == 2){
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Movies(),
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

  void _goToSerieDetail() {
    if(posty >= 0 ){
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Serie(serie:series[_focused_poster]),
          transitionDuration: Duration(seconds: 0),
        ),
      );
      FocusScope.of(context).requestFocus(null);
    }
  }
  void _showGenresDialog() {
    if (posty == -1 && postx == 0) {
      setState(() {
        _visibile_genres_dialog = true;
      });
      Future.delayed(Duration(milliseconds: 100),(){
        _genresScrollController.scrollTo(index: _selected_genre,alignment: 0.43,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
      });
    }

  }

  void _selectedGenre() {
    _selected_genre = _focused_genre;
    setState(() {
      _visibile_genres_dialog = false;
    });
    _getList();
  }

  Widget _seriesLineGridWidget( jndex, int itemCount) {
    return Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: 150,
            width: double.infinity,
            child: ScrollablePositionedList.builder(
              itemCount: itemCount,
              itemScrollController: _scrollControllers[jndex],
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {

                return GestureDetector(
                    onTap: (){
                      setState(() {
                        posty = jndex;
                        postx =index;
                        Future.delayed(Duration(milliseconds: 250),(){
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) => Serie(serie: series[(jndex*8)+index]),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        });
                      });
                    },
                    child: MovieWidget(isFocus:  ((posty == jndex && postx == index)),movie: series[(jndex*8)+index])
                );
              },
            ),
          )
        ],
      ),
    );
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
  void closeGenreDialog(){
    setState(() {
      _visibile_genres_dialog = false;
    });
  }
  void selectGenre(int selected_genre_pick){
    setState(() {
      _focused_genre =  selected_genre_pick;
      Future.delayed(Duration(milliseconds: 200),(){
        _selectedGenre();
      });
    });
  }
}




class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}