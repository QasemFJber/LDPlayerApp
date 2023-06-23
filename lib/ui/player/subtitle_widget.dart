
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/subtitle.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SubtitleWidget extends StatelessWidget {
  bool isFocused;
  Subtitle subtitle;

  SubtitleWidget({required this.isFocused, required this. subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          if(subtitle.id != -1)
            Container(
              padding: const EdgeInsets.all(7),
              child: CachedNetworkImage(imageUrl: subtitle.image,width: 30,height: 30),
              decoration: BoxDecoration(
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(7),
              child: Icon(
                  Icons.subtitles,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              (subtitle.id == -1)?"Disable Subtitles":subtitle.language,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color:  (isFocused)?Colors.black.withOpacity(0.9):Colors.white.withOpacity(0),
      ),
    );
  }
}
