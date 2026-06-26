abstract class Post {
  final String? id;
  final String type;
  final DateTime timestamp;

  Post({required this.type, required this.timestamp, this.id});
  Map<String, dynamic> toJson(); // abstract method
  factory Post.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'countdown':
        return CountdownPost.fromJson(json);
      case 'notice':
        return NoticePost.fromJson(json);
      case 'birthday':
        return BirthdayPost.fromJson(json);
      default:
        throw ArgumentError('Unsupported post type: ${json['type']}');
    }
  }
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
      'endDate': endDate.toIso8601String(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON
  factory CountdownPost.fromJson(Map<String, dynamic> json) {
    return CountdownPost(
      message: json['message'].toString(),
      endDate: DateTime.parse(json['endDate'].toString()),
      timestamp: DateTime.parse(json['timestamp'].toString()),
      id: json['id']?.toString(),
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
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle ?? '',
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory NoticePost.fromJson(Map<String, dynamic> json) {
    return NoticePost(
      title: json['title'].toString(),
      subtitle: json['subtitle']?.toString() ?? '',
      content: json['content'].toString(),
      timestamp: DateTime.parse(json['timestamp'].toString()),
      id: json['id']?.toString(),
    );
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
    return {
      'id': id,
      'type': type,
      'name': name,
      'birthday': birthday.toIso8601String(),
      'photoUrl': photoURL ?? '',
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory BirthdayPost.fromJson(Map<String, dynamic> json) {
    return BirthdayPost(
      name: json['name'].toString(),
      birthday: DateTime.parse(json['birthday'].toString()),
      photoURL: json['photoUrl']?.toString(),
      timestamp: DateTime.parse(json['timestamp'].toString()),
    );
  }
}
