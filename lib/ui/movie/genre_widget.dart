import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_tv/model/genre.dart';
import 'package:flutter_app_tv/ui/movie/movies.dart';

class GenreWidget extends StatelessWidget {
  bool? isFocused;
  int? selected_genre;
  int? index;
  Genre? genre;

  GenreWidget({this.isFocused,this.selected_genre, this.index,this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              genre!.title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            child: Theme(
              data: ThemeData.dark(),
              child: Radio(
                  value:index!,
                  activeColor: Colors.white,
                  groupValue: selected_genre, onChanged: (int? value) {  },
              ),
            ),
            decoration: BoxDecoration(
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color:  (isFocused!)?Colors.black.withOpacity(0.9):Colors.white.withOpacity(0),
      ),
    );;
  }
}