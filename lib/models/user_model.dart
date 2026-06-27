class UserModel {
  final String id;
  final String name;
  final String profileUrl;
  final List<dynamic> roles;
  final DateTime birthday;
  final String courseId;

  // Method to convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "profileUrl": profileUrl,
      "roles": roles,
      'birthday': birthday,
      'courseId': courseId,
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
      courseId: json['courseId'],
    );
  }

  UserModel({
    required this.id,
    required this.name,
    required this.profileUrl,
    required this.roles,
    required this.birthday,
    required this.courseId,
  });
}
