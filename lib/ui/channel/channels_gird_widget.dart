import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/channel.dart';
import 'package:flutter_app_tv/ui/channel/channels.dart';
import 'package:flutter_app_tv/ui/movie/movies.dart';
import 'package:flutter_app_tv/ui/channel/channel_widget.dart';
import 'package:flutter_app_tv/ui/movie/movie_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChannelsGridWidget extends StatelessWidget {
  int posty;
  int postx;
  int jndex;
  int itemCount;
  List<Channel> channels = [];
  ItemScrollController scrollController;


  ChannelsGridWidget({required this.posty, required this.postx, required this.jndex, required this.scrollController,required this.itemCount});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            height: 75,
            width: double.infinity,
            child: ScrollablePositionedList.builder(
              itemCount: itemCount,
              itemScrollController: scrollController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return ChannelWidget(isFocus:  ((posty == jndex && postx == index)),channel: channels[(jndex*6)+index]);
              },
            ),
          )
        ],
      ),
    );
  }
}
