class User {
  final String id;
  final int name;
  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
  );


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
    'id': id,
    'name' : name
    };
  }
}