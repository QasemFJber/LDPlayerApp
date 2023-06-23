import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/country.dart';
import 'package:flutter_app_tv/ui/channel/channels.dart';
import 'package:flutter_app_tv/ui/movie/movies.dart';

class CountryWidget extends StatelessWidget {
  bool isFocused;
  int selected_country;
  Country country;
  int index;

  CountryWidget({required this.isFocused,required this.selected_country, required this.index,required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                if(country.image != '')
                CachedNetworkImage(imageUrl: country.image,height: 30,width: 30),
                SizedBox(width: 10),
                Text(
                  country.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Theme(
              data: ThemeData.dark(),
              child: Radio(
                  value:index,
                  activeColor: Colors.white,
                  groupValue: selected_country, onChanged: (int? value) {  },
              ),
            ),
            decoration: BoxDecoration(
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color:  (isFocused)?Colors.black.withOpacity(0.9):Colors.white.withOpacity(0),
      ),
    );;
  }
}