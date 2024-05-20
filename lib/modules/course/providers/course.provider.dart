import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/utils/utils.dart';

class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<CourseModel> _courseList = [];
  bool _isLoading = false;

  List<CourseModel> get courseList => _courseList;
  bool get isLoading => _isLoading;

  CourseProvider() {}

  Future<void> fetchCourses(BuildContext context, String instituteId) async {
    _isLoading = true;
    notifyListeners();
    try {
      DocumentReference instituteRef = _firebaseFirestore
          .collection(RecdatCollections.institutes())
          .doc(instituteId);

      QuerySnapshot snapshot =
          await instituteRef.collection(RecdatCollections.courses()).get();

      _courseList = snapshot.docs
          .map((doc) => CourseModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      print("COURSE TYPE FETCHING: ${_courseList[0].type}");
      showSnackBar(
          context, "Todos los cursos han sido cargados", SnackBarType.success);
    } catch (e) {
      showSnackBar(
          context, "Ups! no pudimos cargar los cursos", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCourse(
      BuildContext context, CourseModel course, String instituteId) async {
    _isLoading = true;
    notifyListeners();
    try {
      DocumentReference instituteRef =
          _firebaseFirestore.collection("institutes").doc(instituteId);

      course.createdAt = RecdatDateUtils.currentDate();

      await instituteRef.collection("courses").add(course.toMap());

      showSnackBar(context, "Curso creado exitosamente!", SnackBarType.success);
    } catch (e) {
      showSnackBar(context, "Ups! no se registró el curso", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCourse(CourseModel course) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseFirestore
          .collection("courses")
          .doc(course.uid)
          .update(course.toMap());
      int index = _courseList.indexWhere((c) => c.uid == course.uid);
      if (index != -1) {
        _courseList[index] = course;
      }
    } catch (e) {
      print("Error updating course: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCourse(String courseId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseFirestore.collection("courses").doc(courseId).delete();
      _courseList.removeWhere((course) => course.uid == courseId);
    } catch (e) {
      print("Error deleting course: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
