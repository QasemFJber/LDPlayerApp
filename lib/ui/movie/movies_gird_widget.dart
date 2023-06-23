import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/poster.dart';
import 'package:flutter_app_tv/ui/movie/movie_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MoviesGridWidget extends StatelessWidget {
  int? posty;
  int? postx;
  int? jndex;
  int? itemCount;
  List<Poster>? posters;
  ItemScrollController? scrollController;


  MoviesGridWidget({this.posty, this.postx, this.jndex, this.scrollController,this.itemCount,this.posters});
  @override
  Widget build(BuildContext context) {
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
              itemCount: itemCount!,
              itemScrollController: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return MovieWidget(isFocus:  ((posty == jndex && postx == index)),movie: posters![(jndex!*8)+index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
