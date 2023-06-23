class Source{
   int id;
  String type;
  String? title;
  String? quality;
  String? size;
  String kind;
  String? premium;
  bool? external;
  String url;

  Source({required this.id,required this.type,required this.title,required this.quality,required this.size,required this.kind,required
      this.premium,required this.external,required this.url});

   factory Source.fromJson(Map<String, dynamic> parsedJson){
     return Source(
          id: parsedJson['id'],
          title : parsedJson['title'],
          type : parsedJson['type'],
          quality : parsedJson['quality'],
          size : parsedJson['size'],
          premium : parsedJson['premium'].toString(),
          external : parsedJson['external'],
          url : parsedJson['url'],
          kind: parsedJson['url']
     );
   }

}

