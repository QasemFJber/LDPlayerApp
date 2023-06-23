import 'package:flutter_app_tv/model/category.dart';
import 'package:flutter_app_tv/model/channel.dart';
import 'package:flutter_app_tv/model/genre.dart';
import 'package:flutter_app_tv/model/poster.dart';

class Slide{
    int id;
    String title;
    String type;
    String image;
    String url;
    Poster? poster;
    Category? category;
    Genre? genre;
    Channel? channel;

    Slide({required this.id,required this.title,required this.type,required this.image,required this.url, this.poster,required
      this.category,required this.genre,required this.channel});

    factory Slide.fromJson(Map<String, dynamic> parsedJson){


      return Slide(
            id: parsedJson['id'],
            title : parsedJson['title'],
            type : parsedJson['type'],
            image : parsedJson['image'],
            url : (parsedJson['url'] != null)? parsedJson['url']: "",
            poster : (parsedJson['poster']!= null )? Poster.fromJson(parsedJson['poster']):null,
            genre : (parsedJson['genre']!= null )?Genre.fromJson(parsedJson['genre']):null,
            channel :  (parsedJson['channel']!= null )?Channel.fromJson(parsedJson['channel']):null,
            category: Category( title: '', id: 0),
      );
    }
}