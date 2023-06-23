import 'dart:convert';


class Review{
  int id;
  String user;
  String image;
  String? content;
  String created;
  double rating;


  Review({required this.id, required this.user, required this.image, required this.content, required this.created,required  this.rating});

  factory Review.fromJson(Map<String, dynamic> parsedJson){
    double _rating =double.parse(parsedJson['rating'].toString());
    return Review(
        id: parsedJson['id'],
        user : parsedJson['user'],
        image : parsedJson['image'],
        content : parsedJson['content'],
        created : parsedJson['created'],
        rating : _rating,
    );
  }
}