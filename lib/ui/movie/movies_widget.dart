import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/model/poster.dart';
import 'package:flutter_app_tv/ui/movie/movie.dart';
import 'package:flutter_app_tv/ui/movie/movie_widget.dart';
import 'package:flutter_app_tv/ui/movie/movies.dart' as isss;
import 'package:flutter_app_tv/ui/serie/serie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MoviesWidget extends StatefulWidget {
  String? title;
  List<Poster>? posters =[];
  int? size;
  int? posty;
  int? postx;
  int? jndex;
  ItemScrollController? scrollController;


  MoviesWidget({this.posty, this.postx, this.jndex, this.scrollController,this.title,this.posters, this.size});

  @override
  _MoviesWidgetState createState() => _MoviesWidgetState();
}

class _MoviesWidgetState extends State<MoviesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.only(left: 50,bottom: 5),
            height: 22,
            child: Text(
              widget.title!,
              style: TextStyle(
                  color: (widget.jndex == widget.posty)?Colors.white:Colors.white60,
                  fontSize: (widget.size == null)? 14: 13,
                  fontWeight: FontWeight.w900
              ),
            ),
          ),
          Container(
            height: 150,
            width: double.infinity,
            child: ScrollConfiguration(
              behavior: MyBehavior(),   //
              child: ScrollablePositionedList.builder(
                itemCount: widget.posters!.length,
                itemScrollController: widget.scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.only(left:(0==index)?40:0),
                    child: GestureDetector(
                        onTap: (){
                              setState(() {
                                widget.posty = widget.jndex;
                                widget.postx =index;
                                Future.delayed(Duration(milliseconds: 250),(){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation1, animation2) => ( widget.posters![index].type == "serie")? Serie(serie: widget.posters![index]):Movie(movie: widget.posters![index]),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                  );
                                });
                              });
                        },
                        child: MovieWidget(isFocus:  ((widget.posty == widget.jndex && widget.postx == index)),movie: widget.posters![index])
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
