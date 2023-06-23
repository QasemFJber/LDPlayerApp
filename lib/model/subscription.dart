import 'dart:convert';


class Subscription{
  int id;
  String price;
  String date;
  String expired;
  String state;
  String pack;


  Subscription({required this.id,required this.price,required this.date,required this.expired,required this.state,required this.pack});

  factory Subscription.fromJson(Map<String, dynamic> parsedJson){



    return Subscription(
        id: parsedJson['id'],
        price : parsedJson['price'],
        date : parsedJson['date'],
        expired : parsedJson['expired'],
        state : parsedJson['state'],
        pack : parsedJson['pack']
    );
  }
}