class UserModel {
  final String id;
  final String name;
  final String profileUrl;
  final List<dynamic> roles;
  final DateTime? birthday;

  // Method to convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "profileUrl": profileUrl,
      "roles": roles,
      'birthday': birthday,
    };
  }

  // Method to convert JSON to
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      profileUrl: json["profileUrl"],
      roles: json['roles'],
      birthday: DateTime.parse(json['birthday']),
    );
  }

  UserModel({
    required this.id,
    required this.name,
    required this.profileUrl,
    required this.roles,
    this.birthday,
  });
}
