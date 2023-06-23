
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/channel.dart';

class ChannelWidget extends StatelessWidget {
  bool isFocus ;
  Channel channel ;
  ChannelWidget({required this.isFocus,required this.channel});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        child: ClipRRect(
            child: CachedNetworkImage(
              imageUrl: channel.image,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(5)
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.blueGrey,
          border: (isFocus)?Border.all(color: Colors.purple,width: 2):Border.all(color: Colors.transparent,width: 0),
          boxShadow: [
            BoxShadow(
                color: (isFocus)?Colors.purple:Colors.white.withOpacity(0),
                offset: Offset(0,0),
                blurRadius: 6
            ),
          ],
        ),
        width: 136,
      ),
    );
  }
}