import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/ui/player/video_player.dart';

class VideoControllerWidget extends StatelessWidget {
  bool? visibile_controllers;
  bool? visibile_subtitles_dialog;
  bool? visibileSourcesDialog;
  int?  post_x;
  int?  post_y;

  String? title;
  String? next_title;
  bool? next = false;
  bool? live = false;

  double?  slider_video_value = 0;


  int?  video_controller_play_position = 0;
  int?  video_controller_slider_position = 1;
  int?  video_controller_settings_position = 2;




  BetterPlayerController? betterPlayerController;
  AnimationController? animated_controller;

  Function()? autohide;

  Function()? pauseplay;
  Function()? fastRewind;
  Function()? fastForward;
  Function()? playnext;

  Function()? subtitles;
  Function()? sources;

  Function()? tostart;

  VideoControllerWidget(
      {
        this.visibile_controllers,
        this.visibile_subtitles_dialog,
        this.visibileSourcesDialog,
        this.post_x,
        this.post_y,
        this.slider_video_value,
        this.betterPlayerController,
        this.animated_controller,
        this.video_controller_play_position,
        this.video_controller_slider_position,
        this.video_controller_settings_position,
        this.title,
        this.next,
        this.next_title,
        this.live,
        this.autohide,
        this.pauseplay,
        this.fastRewind,
        this.fastForward,
        this.playnext,
        this.sources,
        this.subtitles,
        this.tostart
  });

  @override
  Widget build(BuildContext context) {
    return   Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Visibility(
        visible: (visibile_controllers! && !visibile_subtitles_dialog! && !visibileSourcesDialog!),
        child: GestureDetector(
          onTap: (){
            autohide!();
          },
          child: Container(
            color: Colors.black87,
            child: Stack(
              children: [
                Positioned(
                  left: 40,
                  right: 40,
                  bottom: 40,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        pauseplay!();
                                        autohide!();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child:
                                        Center(
                                          child: AnimatedIcon(
                                            icon: AnimatedIcons.play_pause,
                                            progress: animated_controller!,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                            color: (post_x == 0 && post_y == video_controller_play_position )? Colors.white24:Colors.transparent,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: (){
                                        tostart!();
                                        autohide!();

                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Icon(Icons.skip_previous,color: Colors.white,size: 35),
                                        decoration: BoxDecoration(
                                            color: (post_x == 1 && post_y == video_controller_play_position )? Colors.white24:Colors.transparent,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: (){
                                        fastRewind!();
                                        autohide!();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Icon(Icons.fast_rewind,color: Colors.white,size: 35),
                                        decoration: BoxDecoration(
                                            color: (post_x == 2 && post_y == video_controller_play_position )? Colors.white24:Colors.transparent,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: (){
                                        fastForward!();
                                        autohide!();
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child: Icon(Icons.fast_forward,color: Colors.white,size: 35),
                                        decoration: BoxDecoration(
                                            color: (post_x == 3 && post_y == video_controller_play_position )? Colors.white24:Colors.transparent,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                              if(next!)
                                GestureDetector(
                                  onTap: (){
                                    playnext!();
                                    autohide!();
                                  },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Text(
                                        next_title!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),
                                      ),
                                      Icon(Icons.skip_next,color: Colors.white,size: 35),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white38),
                                      color: (post_x == 4 && post_y == video_controller_play_position )? Colors.white24:Colors.transparent,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ValueListenableBuilder(
                            valueListenable: betterPlayerController!.videoPlayerController!,
                            builder: (context, VideoPlayerValue value, child) {
                              slider_video_value = durationToInt(value.position,betterPlayerController!);

                              //Do Something with the value.
                              return Container(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    trackShape: CustomTrackShape(),
                                    activeTrackColor:  (post_y == video_controller_slider_position)? Colors.purple :Colors.purple.withOpacity(0.5),
                                    thumbColor: (post_y == video_controller_slider_position)? Colors.deepPurple :Colors.purple,
                                    showValueIndicator: ShowValueIndicator.always,
                                  ),
                                  child: Slider(
                                    inactiveColor: Colors.white38,

                                    min: 0,
                                    max: 100,
                                    value: slider_video_value!,
                                    onChanged: (value) {

                                    },
                                    onChangeStart: (va){
                                      print("onChangeStart");
                                    },

                                    onChangeEnd: (va){
                                      print("onChangeEnd");
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      subtitles!();
                                    }
                                    ,
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      child: Icon(Icons.subtitles,color: (live!)? Colors.white38:Colors.white,size: 35),
                                      decoration: BoxDecoration(
                                          color: (post_x == 0 && post_y == video_controller_settings_position )? Colors.white24:Colors.transparent,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 25),

                                  GestureDetector(
                                    onTap: (){
                                      sources!();
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      child: Icon(Icons.high_quality,color: Colors.white,size: 35),
                                      decoration: BoxDecoration(
                                          color: (post_x == 1 && post_y == video_controller_settings_position )? Colors.white24:Colors.transparent,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            if(live!)
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                        "LIVE",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 18
                                        ),
                                    ),
                                  ],
                                ),
                              )
                              else
                            Container(
                                child:Row(
                                  children: [
                                    ValueListenableBuilder(
                                      valueListenable: betterPlayerController!.videoPlayerController!,
                                      builder: (context, VideoPlayerValue value, child) {
                                        //Do Something with the value.
                                        return Text(
                                          _printDuration(value.position),
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 18
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      " / ",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: betterPlayerController!.videoPlayerController!,
                                      builder: (context, VideoPlayerValue value, child) {
                                        //Do Something with the value.
                                        return Text(
                                          _printDuration(value.duration),
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 18
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                )
                            )
                          ],
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
    );
  }

}
class CustomTrackShape extends RoundedRectSliderTrackShape {
      Rect getPreferredRect({required RenderBox parentBox, Offset offset = Offset.zero, required SliderThemeData sliderTheme, bool isEnabled = false, bool isDiscrete = false
    }) {
        final double? trackHeight = sliderTheme.trackHeight;
      final double trackLeft = offset.dx;
      final double? trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
      final double trackWidth = parentBox.size.width;
      return Rect.fromLTWH(trackLeft, trackTop!, trackWidth, trackHeight);
      }
  }


double durationToInt(Duration duration,BetterPlayerController _betterPlayerController)  {
  if(duration != null && _betterPlayerController.videoPlayerController!.value.duration!=null){
    int milli_second_duration =  _betterPlayerController.videoPlayerController!.value.duration!.inMilliseconds;
    int milli_second_position = duration.inMilliseconds;
    double position_int = (milli_second_position/milli_second_duration)*100;
    return (position_int>100)? 100:((position_int<0)? 0:position_int);
  }
  return 0;
}
String _printDuration(Duration? duration) {

  if(duration == null){
    return "00:00:00";
  }
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

