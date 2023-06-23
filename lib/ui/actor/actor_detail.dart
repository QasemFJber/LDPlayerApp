import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/model/actor.dart';
import 'package:flutter_app_tv/model/poster.dart';
import 'package:flutter_app_tv/test.dart';
import 'package:flutter_app_tv/ui/channel/channels.dart';
import 'package:flutter_app_tv/ui/movie/movie.dart';
import 'package:flutter_app_tv/ui/movie/movies_widget.dart';
import 'package:flutter_app_tv/ui/movie/related_loading_widget.dart';
import 'package:flutter_app_tv/ui/serie/serie.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert' as convert;

import 'package:transparent_image/transparent_image.dart';

class ActorDetail extends StatefulWidget {
  Actor actor;


  ActorDetail({required this.actor});

  @override
  _ActorDetailState createState() => _ActorDetailState();
}

class _ActorDetailState extends State<ActorDetail> {

  int postx = 0;
  int posty = 1;
  FocusNode actor_focus_node = FocusNode();
  ItemScrollController _scrollController = ItemScrollController();
  ItemScrollController _moviesScrollController = ItemScrollController();
  bool _visibile_related_loading= true;
  List<Poster> movies =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(actor_focus_node);

      _getMoviesList();
    });
  }

  void _getMoviesList()  async{

    movies.clear();
    setState(() {
      _visibile_related_loading=true;
    });
    var response =await apiRest.getMoviesByActor(widget.actor.id);
    if(response != null){
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        for(Map<String,dynamic> i in jsonData){
          Poster _poster = Poster.fromJson(i);
          movies.add(_poster);
        }
      }
    }
    setState(() {
      _visibile_related_loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
     return  WillPopScope(
      onWillPop: () async{

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: RawKeyboardListener(
          focusNode: actor_focus_node,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
              RawKeyDownEvent rawKeyDownEvent = event;

              RawKeyEventDataAndroid rawKeyEventDataAndroid =rawKeyDownEvent.data as RawKeyEventDataAndroid;
              switch (rawKeyEventDataAndroid.keyCode) {
                case KEY_CENTER:
                  _goToMovieDetail();

                  break;
                case KEY_UP:
                  if(posty == 0){
                    print("play sound");
                  }else{
                    posty--;
                    _scrollToIndexY(posty);
                  }
                  break;
                case KEY_DOWN:
                  if(posty == 1){
                    print("play sound");
                  }else {
                    posty++;
                    _scrollToIndexY(posty);
                  }
                  break;
                case KEY_LEFT:
                  if(postx == 0){
                    print("play sound");
                  }else{
                    postx -- ;
                    _scrollToIndexMovie(postx);
                  }
                  break;
                case KEY_RIGHT:
                  if(postx == movies.length-1){
                    print("play sound");
                  }else{
                    postx ++;
                    _scrollToIndexMovie(postx);
                  }
                  break;
                default:
                  break;
              }
              print("x : "+postx.toString()+" y = "+posty.toString());
              setState(() {

              });
            
            }
          },
          child: Container(
            child: Stack(
              children: [
                FadeInImage(placeholder: MemoryImage(kTransparentImage), image: CachedNetworkImageProvider(widget.actor.image.replaceAll("uploads/cache/actor_thumb/", "")),fit: BoxFit.cover,height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width),

                ClipRRect( // Clip it cleanly.
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Container(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ScrollablePositionedList.builder(
                          itemCount: 3,
                          itemScrollController: _scrollController,
                          itemBuilder: (context, index) {
                            switch(index){
                              case 0:
                                return Container(
                                  padding: EdgeInsets.only(left: 50,right: 50,bottom: 20,top: 100),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: CachedNetworkImage(
                                                    imageUrl:widget.actor.image.replaceAll("uploads/cache/actor_thumb/", ""),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child:  Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.actor. name.toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text("${widget.actor.type}", style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w800
                                                  ),),
                                                  SizedBox(width: 5),
                                                  Text(" •  ${widget.actor.born} "
                                                    , style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w800
                                                    ),
                                                  )
                                                  ,
                                                  SizedBox(width: 5),
                                                  Text(" •  ${widget.actor.height} "
                                                    , style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w800
                                                    ),
                                                  )

                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Text(widget.actor.bio+widget.actor.bio
                                                , style: TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 11,
                                                    height: 1.5,
                                                    fontWeight: FontWeight.normal
                                                ),
                                              ),
                                              SizedBox(height: 10),

                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                                break;

                              case 1:
                                return  Container(
                                  padding: EdgeInsets.only(top: 5,bottom: 20),
                                  child: Column(
                                    children: [
                                      if(!_visibile_related_loading)
                                        MoviesWidget(title: "Filmography",size: 13,scrollController: _moviesScrollController,postx: postx,jndex: 1,posty: posty,posters: movies)
                                      else
                                        RelatedLoadingWidget(),
                                    ],
                                  ),
                                );
                                break;
                              default:
                                return Container();
                                break;
                            }
                          }),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future _scrollToIndexY(int y) async {
    _scrollController.scrollTo(index: y,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
  }
  Future _scrollToIndexMovie(int y) async {
    _moviesScrollController.scrollTo(index: y,alignment: 0.04,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
  }

  void _goToMovieDetail() {
    if(posty == 2 ){
      if(movies.length>0){
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => (movies[postx].type == "serie")? Serie(serie:movies[postx]):Movie(movie:movies[postx]),
            transitionDuration: Duration(seconds: 0),
          ),
        );
        FocusScope.of(context).requestFocus(null);
      }

    }
  }
}
