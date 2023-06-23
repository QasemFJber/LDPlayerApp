import 'package:flutter_app_tv/model/poster.dart';

class Category{
  int id;
  String title;

  Category({required this.id, required this.title});

  factory Category.fromJson(Map<String, dynamic> parsedJson){




    return Category(
        id: parsedJson['id'],
        title : parsedJson['title'],
    );
  }
}