class Subtitle{
  int id;
  String type;
  String language;
  String url;
  String image;

  Subtitle({required this.id,required this.type,required  this.language,required this.url,required this.image});

  factory Subtitle.fromJson(Map<String, dynamic> parsedJson){
    print(parsedJson);
    return Subtitle(
        id: parsedJson['id'],
        type : parsedJson['type'],
        language : parsedJson['language'],
        url : parsedJson['url'],
        image : parsedJson['image']
    );
  }

}

