import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_tv/api/api_rest.dart';
import 'package:flutter_app_tv/model/category.dart';
import 'package:flutter_app_tv/model/channel.dart';
import 'package:flutter_app_tv/model/country.dart';
import 'package:flutter_app_tv/model/source.dart';
import 'package:flutter_app_tv/ui/auth/auth.dart';
import 'package:flutter_app_tv/ui/auth/login.dart';
import 'package:flutter_app_tv/ui/channel/channel_widget.dart';
import 'package:flutter_app_tv/ui/channel/channels_gird_widget.dart';
import 'package:flutter_app_tv/ui/channel/related_channel_loading_widget.dart';
import 'package:flutter_app_tv/ui/comment/comments.dart';
import 'package:flutter_app_tv/ui/dialogs/sources_dialog.dart';
import 'package:flutter_app_tv/ui/dialogs/subscribe_dialog.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/key_code.dart';
import 'package:flutter_app_tv/ui/movie/related_loading_widget.dart';
import 'package:flutter_app_tv/ui/review/review_add.dart';
import 'package:flutter_app_tv/ui/player/video_player.dart';
import 'package:flutter_app_tv/ui/channel/channels_widget.dart';
import 'package:flutter_app_tv/ui/movie/movies_widget.dart';
import 'package:flutter_app_tv/ui/review/reviews.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:convert' as convert;

import 'package:url_launcher/url_launcher.dart';

class ChannelDetail extends StatefulWidget {

    Channel? channel;
    String categories_id ="";

    ChannelDetail({this.channel}){
      int i =0;
      for(Category g in channel!.categories){
        if(i == channel!.categories.length-1)
          categories_id +=g.id.toString();
        else
          categories_id +=g.id.toString()+ ",";

        i++;
      }
      print(categories_id);
    }


  @override
  _ChannelDetailState createState() => _ChannelDetailState();
}

class _ChannelDetailState extends State<ChannelDetail> {

  int postx = 0;
  int posty = 0;
  bool _visibile_related_loading = false;
  bool visible_subscribe_dialog = false;
  bool visibileSourcesDialog= false;

  List<Channel> channels =[];
  int _selected_source= 0;
  int _focused_source= 0;

  FocusNode movie_focus_node = FocusNode();
  ItemScrollController _scrollController = ItemScrollController();
  ItemScrollController _moviesScrollController = ItemScrollController();
  ItemScrollController _sourcesScrollController = ItemScrollController();

  bool? logged =false;
  bool added =false;

  bool my_list_loading = false;

  String subscribed = "FALSE";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(null);
      FocusScope.of(context).requestFocus(movie_focus_node);
      _getRelatedList();
      _checkLogged();
    });
  }
  void _checkLogged()  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.logged = prefs.getBool("LOGGED_USER");
    this. subscribed =  prefs.getString("NEW_SUBSCRIBE_ENABLED")!;

    _checkMylist();
  }
  void _checkMylist() async{

    if(logged == true ){
      setState(() {
        my_list_loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? id_user =  prefs.getInt("ID_USER");
      String? key_user =  prefs.getString("TOKEN_USER");
      var data =  {"key":key_user,"user":id_user.toString(),"id": widget.channel!.id.toString(),"type":"channel"};
      var response =await apiRest.checkMyList(data);
      print(response.body);

      if(response != null){
        if(response.statusCode == 200){
          if(response.body.toString() == "200"){
            setState(() {
              added = true;
            });
          }else{
            added = false;
          }
        }
      }
      setState(() {
        my_list_loading = false;
      });
    }

  }
  void _addMylist() async{

    if(posty ==  0 && postx  ==  2){
      if(logged == true){
      setState(() {
        my_list_loading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? id_user =  prefs.getInt("ID_USER");
      String? key_user =  prefs.getString("TOKEN_USER");
      var data =  {"key":key_user,"user":id_user.toString(),"id": widget.channel!.id.toString(),"type":"channel"};
      var response =await apiRest.addMyList(data);
      print(response.body);

      if(response != null){
        if(response.statusCode == 200){
          if(response.body.toString() == "200"){
            setState(() {
              added = true;
            });
          }else{
            setState(() {
              added = false;
            });
          }
        }
      }
      setState(() {
        my_list_loading = false;
      });
      }else{
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Auth(),
            transitionDuration: Duration(seconds: 0),
          ),
        );
      }
    }

  }
  void _getRelatedList()  async{

    channels.clear();
    setState(() {
      _visibile_related_loading=true;
    });
    var response =await apiRest.getChannelsByCategories(widget.categories_id);
    if(response != null){
      if (response.statusCode == 200) {
        var jsonData =  convert.jsonDecode(response.body);
        for(Map<String,dynamic> i in jsonData){
          Channel _channel = Channel.fromJson(i);
          channels.add(_channel);
        }
      }
    }
    setState(() {
      _visibile_related_loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(visible_subscribe_dialog){
          setState(() {
            visible_subscribe_dialog = false;
          });
          return false;
        }
        if(visibileSourcesDialog){
          setState(() {
            visibileSourcesDialog = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: RawKeyboardListener(
          focusNode: movie_focus_node,
          onKey: (RawKeyEvent event) {
            if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
              RawKeyDownEvent rawKeyDownEvent = event;
              RawKeyEventDataAndroid rawKeyEventDataAndroid =rawKeyDownEvent.data as RawKeyEventDataAndroid;
              print("Focus Node 0 ${rawKeyEventDataAndroid.keyCode}");
              switch (rawKeyEventDataAndroid.keyCode) {
                case KEY_CENTER:
                  _goToReview();
                  _goToComments();
                  _goToReviews();
                  _openSource();
                  _goToPlayer();
                  _goToChannel();
                  _goToWebsite();
                  _addMylist();
                  break;
                case KEY_UP:
                  if(visibileSourcesDialog){
                    (_focused_source  == 0 )? print("play sound") : _focused_source--;
                    break;
                  }
                  postx = 0;
                  if(posty == 0){
                    print("play sound");
                  }else{
                    posty--;
                    _scrollToIndexY(posty);
                  }
                  if(posty == 1){
                    _scrollToIndexChannel(postx);
                  }
                  break;
                case KEY_DOWN:
                  if(visibileSourcesDialog){
                    (_focused_source  == widget.channel!.sources.length -1 )? print("play sound") : _focused_source++;
                    break;
                  }
                  postx = 0;
                  if(posty == 1){
                    print("play sound");
                  }else {
                    posty++;
                    _scrollToIndexY(posty);
                  }
                  if(posty == 1){
                    _scrollToIndexChannel(postx);
                  }
                  break;
                case KEY_LEFT:
                  if(visibileSourcesDialog){
                    print("play sound");
                    break;
                  }
                  if(postx == 0){
                    print("play sound");
                  }else{
                    postx -- ;

                    if(posty == 1){
                      _scrollToIndexChannel(postx);
                    }
                  }
                  break;
                case KEY_RIGHT:
                  if(visibileSourcesDialog){
                    print("play sound");
                    break;
                  }
                  if(posty == 0){
                    if(postx == 5){
                      print("play sound");
                    }else{
                      postx ++;
                    }
                  }else if(posty == 1){
                    if(postx == 13){
                      print("play sound");
                    }else{
                      postx ++;
                      _scrollToIndexChannel(postx);
                    }
                  }
                  break;
                default:
                  break;
              }
              setState(() {

              });
              if(visibileSourcesDialog && _sourcesScrollController!= null){
                _sourcesScrollController.scrollTo(index: _focused_source,alignment: 0.43,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
              }
            }
          },
          child: Container(

            child: Stack(
              children: [
                FadeInImage(placeholder: MemoryImage(kTransparentImage),image:CachedNetworkImageProvider(widget.channel!.image),fit: BoxFit.cover,height: MediaQuery.of(context).size.height),
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
                    child: ScrollablePositionedList.builder(
                        itemCount: 3,
                        itemScrollController: _scrollController,
                        itemBuilder: (context, index) {
                          switch(index){
                            case 0:
                              return Container(
                                padding: EdgeInsets.only(left: 50,right: 50,bottom: 20,top: 100),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      imageUrl: widget.channel!.image,
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            child:  Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(widget.channel!.title,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.w900
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Text(widget.channel!.rating.toString(), style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w800
                                                    ),),
                                                    RatingBar.builder(
                                                      initialRating: widget.channel!.rating!,
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 15.0,
                                                      ignoreGestures: true,
                                                      unratedColor: Colors.amber.withOpacity(0.4),
                                                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder: (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                      },
                                                    ),
                                                    SizedBox(width: 10),
                                                    for(Country g in widget.channel!.countries)
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Text(" • ",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.w800
                                                              ),
                                                            ),
                                                            CachedNetworkImage(imageUrl: g.image,width: 25),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text(" ${widget.channel!.classification}  ${widget.channel!.getCategoriesList()}"
                                                  , style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w900
                                                  ),),

                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Text(widget.channel!.description
                                    , style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 11,
                                          height: 1.5,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  posty = 0;
                                                  postx =0;
                                                  Future.delayed(Duration(milliseconds: 100),(){
                                                    _goToPlayer();
                                                  });
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white,width: 0.3),
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: (postx == 0 && posty == 0)? Colors.white:Colors.white30,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 28,
                                                      width: 28,
                                                      child: Icon(
                                                        FontAwesomeIcons.play,
                                                        color: (postx == 0 && posty == 0)? Colors.black:Colors.white,
                                                        size: 11,
                                                      ),
                                                    ),
                                                    Text(
                                                        "Play Channel" ,
                                                        style: TextStyle(
                                                            color: (postx == 0 && posty == 0)? Colors.black:Colors.white,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                    SizedBox(width: 5),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  posty = 0;
                                                  postx =1;
                                                  Future.delayed(Duration(milliseconds: 100),(){
                                                    _goToWebsite();
                                                  });
                                                });
                                              },
                                              child: Container(
                                                height: 35,
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white,width: 0.3),
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: (postx == 1 && posty == 0)? Colors.white:Colors.white30,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 28,
                                                      width: 28,
                                                      child: Icon(
                                                        FontAwesomeIcons.globe,
                                                        color: (postx == 1 && posty == 0)? Colors.black:Colors.white,
                                                        size: 11,
                                                      ),
                                                    ),
                                                    Text(
                                                        "Visit website" ,
                                                        style: TextStyle(
                                                            color: (postx == 1 && posty == 0)? Colors.black:Colors.white,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                    SizedBox(width: 5)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: (){
                                                print(visibileSourcesDialog);
                                                setState(() {

                                                  posty = 0;
                                                  postx = 2;
                                                  _addMylist();
                                                });
                                              },
                                              child: Container(
                                                height: 35,
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white,width: 0.3),
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: (postx == 2 && posty == 0)? Colors.white:Colors.white30,
                                                ),
                                                child: Row(
                                                  children: [
                                                    (my_list_loading)?
                                                    Container(
                                                        padding: EdgeInsets.all(9),
                                                        height: 28,
                                                        width: 28,
                                                        child: Container(
                                                            child: CircularProgressIndicator(color: Colors.black,strokeWidth: 2,)
                                                        )
                                                    )
                                                        :
                                                    Container(
                                                      height: 28,
                                                      width: 28,
                                                      child: Icon(
                                                        (added)? FontAwesomeIcons.solidTimesCircle:FontAwesomeIcons.plusCircle,
                                                        color: (postx == 2 && posty == 0)? Colors.black:Colors.white,
                                                        size: 11,
                                                      ),
                                                    ),
                                                    (my_list_loading)?
                                                    Text(
                                                        "Loading ..." ,
                                                        style: TextStyle(
                                                            color: (postx == 2 && posty == 0)? Colors.black:Colors.white,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    )
                                                        :
                                                    Text(
                                                        (added)?
                                                        "Remove from List"
                                                            :
                                                        "Add to My List" ,
                                                        style: TextStyle(
                                                            color: (postx == 2 && posty == 0)? Colors.black:Colors.white,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                    SizedBox(width: 5)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  posty = 0;
                                                  postx =3;
                                                  Future.delayed(Duration(milliseconds: 100),(){
                                                    _goToReview();
                                                  });
                                                });
                                              },
                                              child: Container(
                                                height: 35,
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white,width: 0.3),
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: (postx == 3 && posty == 0)? Colors.white:Colors.white30,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 28,
                                                      width: 28,
                                                      child: Icon(
                                                        FontAwesomeIcons.starHalfAlt,
                                                        color: (postx == 3 && posty == 0)? Colors.black:Colors.white,
                                                        size: 11,
                                                      ),
                                                    ),
                                                    Text(
                                                        "Rate Channel" ,
                                                        style: TextStyle(
                                                            color: (postx == 3 && posty == 0)? Colors.black:Colors.white,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                    SizedBox(width: 5)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  posty = 0;
                                                  postx =4;
                                                  Future.delayed(Duration(milliseconds: 250),(){
                                                    _goToComments();
                                                  });
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 200),
                                                height: 35,
                                                width: (postx == 4 && posty == 0)? 98:35.6,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white,width: 0.3),
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: (postx == 4 && posty == 0)? Colors.white:Colors.white30,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 35,
                                                      width: 35,
                                                      child: Icon(
                                                        FontAwesomeIcons.comments,
                                                        color: (postx == 4 && posty == 0)? Colors.black:Colors.white,
                                                        size: 11,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Visibility(
                                                        visible: (postx == 4 && posty == 0),
                                                        child: Text(
                                                          "Comments" ,
                                                          style: TextStyle(
                                                              color: (postx == 4 && posty == 0)? Colors.black:Colors.white,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w500
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  posty = 0;
                                                  postx =5;
                                                  Future.delayed(Duration(milliseconds: 250),(){
                                                    _goToReviews();
                                                  });
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 200),
                                                height: 35,
                                                width: (postx == 5 && posty == 0)? 88:35.6,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.white,width: 0.3),
                                                  borderRadius: BorderRadius.circular(3),
                                                  color: (postx == 5 && posty == 0)? Colors.white:Colors.white30,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 35,
                                                      width: 35,
                                                      child: Icon(
                                                        FontAwesomeIcons.star,
                                                        color: (postx == 5 && posty == 0)? Colors.black:Colors.white,
                                                        size: 11,
                                                      ),
                                                    ),
                                                    Flexible(
                                                      child: Visibility(
                                                        visible: (postx == 5 && posty == 0),
                                                        child: Text(
                                                          "Reviews" ,
                                                          style: TextStyle(
                                                            color: (postx == 5 && posty == 0)? Colors.black:Colors.white,
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
                                      ChannelsWidget(title: "Related Channels",size: 13,scrollController: _moviesScrollController,postx: postx,jndex: 1,posty: posty,channels:channels)
                                    else
                                      RelatedChannelLoadingWidget(),
                                  ],
                                ),
                              );
                              break;
                            default:
                              return Container();
                              break;
                          }
                        })
                ),
                SourcesDialog(visibileSourcesDialog: visibileSourcesDialog,focused_source: _focused_source,selected_source: _selected_source,sourcesList: widget.channel!.sources,sourcesScrollController: _sourcesScrollController,close: closeSourceDialog,select: selectSource),
                SubscribeDialog(visible:visible_subscribe_dialog ,close:(){
                  setState(() {
                    visible_subscribe_dialog= false;
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _openSource() async{
    if(visibileSourcesDialog) {
      visibileSourcesDialog = false;
      _selected_source = _focused_source;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(widget.channel!.sources[_selected_source].premium == "2" || widget.channel!.sources[_selected_source].premium == "3"){

        if(subscribed == "TRUE"){
            _playSource();
        }else{
            setState(() {
              visible_subscribe_dialog = true;
            });
        }
      }else{
        _playSource();
      }
      setState(() {

      });
    }
  }
  void _playSource() async{
    if (widget.channel!.sources[_selected_source].type == "youtube" || widget.channel!.sources[_selected_source].type == "embed" ) {
      String url = widget.channel!.sources[_selected_source].url;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      int _new_selected_source =0;
      List<Source> _sources = [];
      int j = 0;
      for (var i = 0; i < widget.channel!.sources.length; i++) {
        if(widget.channel!.sources[i].type != "youtube" && widget.channel!.sources[_selected_source].type != "embed" ) {
          print(widget.channel!.sources[i].url);
          _sources.add(widget.channel!.sources[i]);
          if(_selected_source == i){
            _new_selected_source = j;
          }
          j++;
        }
      }
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => VideoPlayer(sourcesList: _sources,selected_source:_new_selected_source,focused_source: _new_selected_source,channel: widget.channel),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    }
  }
  void  _goToReview() async{
    if(posty == 0 && postx == 3){

          SharedPreferences prefs = await SharedPreferences.getInstance();
          logged = prefs.getBool("LOGGED_USER");

          if(logged == true){
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => ReviewAdd(id: widget.channel!.id,type: "channel",image: widget.channel!.image,),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          }else{
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => Auth(),
                transitionDuration: Duration(seconds: 0),
              ),
            );
          }



    }
  }
  void  _goToPlayer(){
    if(posty == 0 && postx  == 0){
      setState(() {
        visibileSourcesDialog= true;
      });
    }
  }
  Future _scrollToIndexY(int y) async {
    _scrollController.scrollTo(index: y,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
  }

  Future _scrollToIndexChannel(int y) async {
    _moviesScrollController.scrollTo(index: y,alignment: 0.04,duration: Duration(milliseconds: 500),curve: Curves.easeInOutQuart);
  }
  void _goToChannel() {
    if(posty >= 1 ){
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
  void  _goToReviews() async{
    if(posty == 0 && postx == 5){

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Reviews(id:widget.channel!.id,title: widget.channel!.title,image: widget.channel!.image,type: "channel"),
            transitionDuration: Duration(seconds: 0),
          ),
        );


    }
  }
  void  _goToComments() async{
    if(posty == 0 && postx == 4){

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Comments(id:widget.channel!.id,enabled:widget.channel!.comment,title: widget.channel!.title,image: widget.channel!.image,type: "channel"),
            transitionDuration: Duration(seconds: 0),
          ),
        );


    }
  }
  void _goToWebsite() async{
    if(postx == 1 && posty ==  0){

      String url = widget.channel!.website!;
      print(url);
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }
  void closeSourceDialog(){
    setState(() {
      visibileSourcesDialog = false;
    });
  }
  void selectSource(int selected_source_pick){
    setState(() {
      _focused_source =  selected_source_pick;
      Future.delayed(Duration(milliseconds: 200),(){
        _openSource();
      });
    });
  }
}
