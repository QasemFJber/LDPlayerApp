import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/country.dart';
import 'package:flutter_app_tv/model/slide.dart';
import 'package:flutter_app_tv/ui/channel/channel_detail.dart';
import 'package:flutter_app_tv/ui/movie/movie.dart';
import 'package:flutter_app_tv/ui/serie/serie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SlideItemWidget extends StatelessWidget {
  int index;

  Slide slide;
  SlideItemWidget({required this.index,required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 50,right: 50),
      child: Stack(
        children: [
          Container(
            margin:  EdgeInsets.only(right: MediaQuery.of(context).size.width/3),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(slide.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w900
                  ),
                ),
                SizedBox(height: 25),
                if(slide.channel != null || slide.poster!= null)
                Row(
                  children: [
                    Text(((slide.poster != null)? slide.poster!.rating : (slide.channel != null)? slide.channel!.rating : "").toString() + " / 5", style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800
                    ),),
                    RatingBar.builder(
                      initialRating: ((slide.poster != null)? slide.poster!.rating : (slide.channel != null)? slide.channel!.rating! : 0),
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
                    if(slide.poster != null)
                    Text("•  ${slide.poster!.imdb} / 10 ", style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800
                      ),
                    ),
                    if(slide.poster != null)
                      Container(
                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text("IMDb", style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800
                      ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                if(slide.channel != null)
                  Row(
                    children: [
                      Text(" ${slide.channel!.classification}  ${slide.channel!.getCategoriesList()}"
                        , style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                for(Country g in slide.channel!.countries)
                  Row(
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
                    ],
                  ),
                if(slide.poster != null)
                  Text("${slide.poster!.year} • ${slide.poster!.classification} • ${slide.poster!.duration} • ${slide.poster!.getGenresList()}"
                    , style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900
                    ),),
                if(slide.channel != null || slide.poster!= null)
                  SizedBox(height: 25),
                if(slide.channel != null || slide.poster!= null)
                  Text(
                      ((slide.poster != null)? slide.poster!.description : (slide.channel != null)? slide.channel!.description : "").toString()
                      , style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          height: 1.5,
                          fontWeight: FontWeight.normal
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 40,
            child: GestureDetector(
              onTap: (){

                if(slide.channel != null){
                  Future.delayed(Duration(milliseconds: 50),(){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => ChannelDetail(channel: slide.channel),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  });
                }
                if(slide.poster != null){
                  Future.delayed(Duration(milliseconds: 50),(){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => ( slide.poster!.type == "serie")? Serie(serie: slide.poster):Movie(movie: slide.poster),
                        transitionDuration: Duration(seconds: 0),
                      ),
                    );
                  });
                }
              },
              child:  GestureDetector(
                onTap: (){

                  if(slide.channel != null){
                    Future.delayed(Duration(milliseconds: 50),(){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => ChannelDetail(channel: slide.channel),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    });
                  }
                  if(slide.poster != null){
                    Future.delayed(Duration(milliseconds: 50),(){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => ( slide.poster!.type == "serie")? Serie(serie: slide.poster):Movie(movie: slide.poster),
                          transitionDuration: Duration(seconds: 0),
                        ),
                      );
                    });
                  }
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          child: Center(child: Icon(Icons.play_arrow,size: 30,color: Colors.white)),
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(width: 1,color:Colors.black12))
                          ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                                "Watch Now",
                                style: TextStyle(
                                    color:Colors.white,
                                    fontWeight: FontWeight.w500
                                ),
                              )
                          )
                      )
                    ],
                  ),
                  height: 40,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

