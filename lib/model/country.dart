import 'package:flutter_app_tv/model/poster.dart';

class Country{
  int id;
  String title;
  String image;


  Country({required this.id, required this.title,required this.image});

  factory Country.fromJson(Map<String, dynamic> parsedJson){




    return Country(
      id: parsedJson['id'],
      title : parsedJson['title'],
      image : parsedJson['image'],
    );
  }
}