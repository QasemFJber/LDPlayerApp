

class Value {
  final int id;
  final String name;
  final String value;

  Value( {required this.id,required this.name,required this.value});

  factory Value.fromJson(Map<String, dynamic> parsedJson){

    return Value(
        id: parsedJson['id'],
        name : parsedJson['name'],
        value : parsedJson['value']
    );
  }
}
