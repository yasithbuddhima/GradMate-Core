import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradmate_core/models/course_model.dart';

class CourseServices {
  static final CourseServices _instance = CourseServices._internal();
  factory CourseServices() => _instance;

  CourseServices._internal();

  List<Course>? _cachedCourses;

  Future<List<Course>> getAllCoursesList() async {
    _cachedCourses = await getAllCourses(); // Your actual fetch logic
    debugPrint("[CourseService.getAllCoursesList] Update all courses.");

    return _cachedCourses!;
  }

  void clearCache() {
    _cachedCourses = null;
  }

  // Method to delete all courses from firebase
  Future<void> deleteAllCourses() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw ("Error deleting courses: $e");
    }
  }

  // Method to add a new course to firebase
  Future<void> addCourse(Course course) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('courses')
          .add(course.toJson());
      // set the document ID to the course ID
      await docRef.update({
        'id': docRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ("Error adding course: $e");
    }
  }

  // Method to update a course in firebase
  Future<void> updateCourse(Course course) async {
    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(course.id)
          .update(course.toJson());
    } catch (e) {
      throw ("Error updating course: $e");
    }
  }

  // Method to get all courses from firebase
  Future<List<Course>> getAllCourses() async {
    List<Course> courses = [];
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .orderBy('createdAt')
          .get();
      for (var doc in snapshot.docs) {
        courses.add(Course.fromJson(doc.data() as Map<String, dynamic>));
      }
      debugPrint(
        "[CourseServices.getAllCourses] All courses fetched from Firestore.",
      );
    } catch (e) {
      throw ("[CourseServices.getAllCourses] Error fetching courses: ${e.toString()}");
    }
    return courses;
  }

  // Method to get a course by its year and semester
  Future<Course?> getCourseByYearAndSemester(int year, int semester) async {
    Course? course;
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .where('year', isEqualTo: year)
          .where('semester', isEqualTo: semester)
          .get();
      if (snapshot.docs.isNotEmpty) {
        course = Course.fromJson(
          snapshot.docs.first.data() as Map<String, dynamic>,
        );
      }
    } catch (e) {
      throw ("Error fetching course: $e");
    }
    return course;
  }

  // Method to get a course by its id
  Future<Course?> getCourseById(String id) async {
    Course? course;
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(id)
          .get();
      if (snapshot.exists) {
        course = Course.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      throw ("Error fetching course: $e");
    }
    return course;
  }
}
