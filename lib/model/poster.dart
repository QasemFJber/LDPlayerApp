import 'package:flutter_app_tv/model/genre.dart';
import 'package:flutter_app_tv/model/source.dart';
import 'package:json_annotation/json_annotation.dart';

class Poster{
     int id ;
     String title ;
     String type ;
     String? label ;
     String? sublabel ;
     double imdb ;
     String? downloadas ;
     bool comment ;
     String? playas ;
     String description ;
     String classification ;
     int year ;
     String duration ;
     double rating ;
     String image ;
     String cover ;
     Source? trailer ;


      List<Genre> genres;

      List<Source> sources;


     Poster({
       required  this.id,
       required  this.title,
       required  this.type,
       required this.label,
       required this.sublabel,
       required this.imdb,
       required this.downloadas,
       required this.comment,
       required this.playas,
       required this.description,
       required this.classification,
       required this.year,
       required  this.duration,
       required this.rating,
       required this.image,
       required this.cover,
       required this.trailer,
       required  this.genres,
       required this.sources
     });

  factory Poster.fromJson(Map<String, dynamic> parsedJson){

      List<Genre> _genres =  [];

      for(Map<String,dynamic> i in parsedJson ['genres']){
        Genre genre = Genre.fromJson(i);
        _genres.add(genre);
      }

      List<Source> _sources =  [];

      for(Map<String,dynamic> i in parsedJson ['sources']){
        Source source = Source.fromJson(i);
        if(source.kind != "download")
            _sources.add(source);
      }
       return Poster(
           id: parsedJson['id'],
           title : parsedJson['title'],
           type : parsedJson['type'],
           label : parsedJson['label'],
           sublabel : parsedJson['sublabel'],
           imdb : (parsedJson['imdb'] == null || parsedJson['imdb'] == 0)? 0 : parsedJson['imdb']*1.00,
           downloadas : parsedJson['downloadas'],
           comment : parsedJson['comment'],
           playas : parsedJson['playas'],
           description :(parsedJson['description'] == null)? "": parsedJson['description'],
           classification :(parsedJson['classification'] == null)? "": parsedJson['classification'],
           year  : parsedJson['year'],
           duration  : parsedJson['duration'],
           rating  :(parsedJson['rating'] == null || parsedJson['rating'] == 0 )? 0 : parsedJson['rating']*1.00,
           image  : parsedJson['image'],
           cover  : (parsedJson['cover'] == null)? "":parsedJson['cover'],
           trailer  : (parsedJson['trailer'] != null)?Source.fromJson(parsedJson['trailer']):null,
            sources: _sources,
            genres: _genres
       );
     }
    String getGenresList(){
      String _genres = "";
      for(Genre g in genres){
        _genres = _genres + " • "+g.title;
      }
      return _genres;
    }
}