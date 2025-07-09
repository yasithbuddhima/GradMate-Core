class Course {
  final String id;
  final String code;
  String? name;
  String? description;
  final int year;
  final int semester;
  final List<String> contents;
  final String evaluationMethod;
  final String? evaluationNote;
  final dynamic createdAt;

  bool isCore;
  CourseDuration courseDuration;
  Credits credits;

  Course({
    required this.id,
    required this.code,
    this.name,
    this.description,
    required this.year,
    required this.semester,
    required this.contents,
    required this.evaluationMethod,
    this.evaluationNote,
    required this.isCore,
    required this.courseDuration,
    required this.credits,
    required this.createdAt,
  });

  // Method to convert CourseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'year': year,
      'semester': semester,
      'contents': contents,
      'evaluations': {
        'evaluationMethod': evaluationMethod,
        'evaluationNote': evaluationNote,
      },

      'isCore': isCore,
      'courseDuration': {
        'lectureTheory': courseDuration.lectureHours,
        'practicalHours': courseDuration.practicalHours,
      },
      'credits': {
        'theoryCredits': credits.theoryCredits,
        'practicalCredits': credits.practicalCredits,
        'totalCredits': credits.totalCredits,
      },
    };
  }

  // Method to convert JSON to CourseModel
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      year: json['year'],
      semester: json['semester'],
      contents: List<String>.from(json['contents']),
      evaluationMethod: json['evaluations']['evaluationMethod'],
      evaluationNote: json['evaluations']['evaluationNote'],
      createdAt: json['createdAt'],
      isCore: json['isCore'] ?? true,
      courseDuration: CourseDuration(
        lectureHours: json['courseDuration']['lectureTheory'],
        practicalHours: json['courseDuration']['practicalHours'],
      ),
      credits: Credits(
        theoryCredits: json['credits']['theoryCredits'],
        practicalCredits: (json['credits']['practicalCredits'] as num)
            .toDouble(),
        totalCredits: (json['credits']['totalCredits'] as num).toDouble(),
      ),
    );
  }
}

// Classes to handle credits
class Credits {
  final int? theoryCredits;
  final double? practicalCredits;
  final double totalCredits;

  Credits({
    required this.theoryCredits,
    required this.practicalCredits,
    required this.totalCredits,
  });
}

// Classes to handle course duration
class CourseDuration {
  final int? lectureHours;
  final String? practicalHours;

  CourseDuration({required this.lectureHours, required this.practicalHours});
}
