import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/ui/home/home.dart';
import 'package:flutter_app_tv/model/subtitle.dart';
import 'package:flutter_app_tv/ui/player/subtitle_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SubtitlesDialog extends StatelessWidget {

  List<Subtitle> subtitlesList = [];
  bool visibile;
  int focused_subtitle;
  int selected_subtitle;
  ItemScrollController subtitlesScrollController = ItemScrollController();

  Function close;

  Function select;


  SubtitlesDialog({required this.subtitlesList,required this.subtitlesScrollController,required this.focused_subtitle,required this.selected_subtitle,required this.visibile, required this.select,required this.close});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Visibility(
          visible: visibile,
          child: Container(
            color: Colors.black87,
            child: Stack(
                children: [
                  Positioned(
                      left: 0,
                      bottom: 0,
                      top: 0,
                      right:(MediaQuery.of(context).size.width/3),
                      child: GestureDetector(
                        onTap: (){
                          close();
                        },
                        child: Container(
                            color:Colors.black.withOpacity(0.1)
                        ),
                      )
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width/3,
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              color: Colors.black45,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 80.0,left: 10,bottom: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.subtitles,color: Colors.white70,size: 35),
                                    SizedBox(width: 10),
                                    Text(
                                      "select your subtitle",
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
                            Expanded(child:
                            Container(
                              color: Colors.black.withOpacity(0.7),
                              child:  ScrollConfiguration(
                                behavior: MyBehavior(),   // From this behaviour you can change the behaviour
                                child: ScrollablePositionedList.builder(
                                  itemCount: subtitlesList.length,
                                  itemScrollController: subtitlesScrollController,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return  GestureDetector(
                                        onTap: (){
                                          select(index);
                                        },
                                        child: SubtitleWidget(isFocused: (index == focused_subtitle),subtitle:subtitlesList[index]));
                                  },
                                ),
                              ),
                            ))
                          ],
                        ),
                      )
                  )
                ]
            ),
          )
      ),
    );
  }
}