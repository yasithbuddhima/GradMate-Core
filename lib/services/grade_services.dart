import 'dart:convert';

import 'package:gradmate_core/models/course_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradeServices {
  Future<List<Course>> updateAllGradesFromLocalStorage(
    List<Course> courses,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? gradesString = pref.getString('grades');
    Map<String, String> coursesWithGrades = {};

    if (gradesString != null && gradesString.isNotEmpty) {
      Map<String, dynamic> rawJson = jsonDecode(gradesString);
      coursesWithGrades = rawJson.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    }

    for (var course in courses) {
      course.grade = Grade.fromLabel(coursesWithGrades[course.code]);
    }
    return courses;
  }
}

// Enum to handle Grade
enum Grade {
  aPlus(label: "A+", gradePoint: 4.0),
  a(label: "A", gradePoint: 4.0),
  aMinus(label: "A-", gradePoint: 3.7),
  bPlus(label: "B+", gradePoint: 3.3),
  b(label: "B", gradePoint: 3.0),
  bMinus(label: "B-", gradePoint: 2.7),
  cPlus(label: "C+", gradePoint: 2.3),
  c(label: "C", gradePoint: 2.0),
  cMinus(label: "C-", gradePoint: 1.7),
  dPlus(label: "D+", gradePoint: 1.3),
  d(label: "D", gradePoint: 1.0),
  e(label: "E", gradePoint: 0.0),
  repeat(label: "Repeat", gradePoint: 0.0);

  final String label;
  final double gradePoint;

  const Grade({required this.label, required this.gradePoint});

  static Grade? fromLabel(String? label) {
    if (label == null || label.isEmpty) return null;

    for (var value in Grade.values) {
      if (value.label == label) return value;
    }

    return null;
  }
}
