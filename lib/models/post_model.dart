abstract class Post {
  final String? id;
  final String type;
  final DateTime timestamp;

  Post({required this.type, required this.timestamp, this.id});
  Map<String, dynamic> toJson(); // abstract method
}

class CountdownPost extends Post {
  final String message;
  final DateTime endDate;

  CountdownPost({
    required this.message,
    required this.endDate,
    required super.timestamp,
    super.id,
  }) : super(type: 'countdown');

  // Convert to JSON
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'message': message,
      'endDate': endDate,
      'timestamp': timestamp,
    };
  }

  // Create from JSON
  factory CountdownPost.fromJson(Map<String, dynamic> json) {
    return CountdownPost(
      message: json['message'],
      endDate: DateTime.parse(json['endDate']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class NoticePost extends Post {
  final String title;
  final String? subtitle;
  final String content;

  NoticePost({
    required this.title,
    this.subtitle,
    required this.content,
    required super.timestamp,
    super.id,
  }) : super(type: 'notice');

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle ?? '',
      'content': content,
      'timestamp': timestamp,
    };
  }
}

class BirthdayPost extends Post {
  final String name;
  final DateTime birthday;
  final String? photoURL;

  BirthdayPost({
    required this.name,
    required this.birthday,
    this.photoURL,
    required super.timestamp,
  }) : super(type: 'birthday');

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'birthday': birthday, 'photoUrl': photoURL ?? ''};
  }
}
