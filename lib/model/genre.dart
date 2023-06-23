import 'package:flutter_app_tv/model/poster.dart';

class Genre{
  int id;
  String title;
  List<Poster>? posters;

  Genre({required this.id, required this.title,this.posters});

  factory Genre.fromJson(Map<String, dynamic> parsedJson){


    List<Poster> posters =  [];
    if(parsedJson['posters'] != null)
    for(Map<String,dynamic> i in parsedJson['posters']){
      Poster poster = Poster.fromJson(i);
      posters.add(poster);
    }

    return Genre(
        id: parsedJson['id'],
        title : parsedJson['title'],
        posters : posters
    );
  }
}