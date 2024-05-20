import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/utils/utils.dart';
import 'package:uuid/uuid.dart';

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
      showSnackBar(context, "Cursos actualizados", SnackBarType.success);
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
      String courseUid = const Uuid().v4();
      course.uid = courseUid;

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

  Future<void> deleteCourse(
      BuildContext context, String courseId, String instituteId) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection("institutes")
          .doc(instituteId)
          .collection("courses")
          .where('uid', isEqualTo: courseId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final courseDoc = querySnapshot.docs.first;
        await courseDoc.reference.delete();
        _courseList.removeWhere((course) => course.uid == courseId);
        showSnackBar(context, "Curso eliminado", SnackBarType.warning);
      } else {
        showSnackBar(
            context, "El curso no fue encontrado", SnackBarType.warning);
      }
    } catch (e) {
      showSnackBar(
          context, "Ups! no se pudo eliminar el curso", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
