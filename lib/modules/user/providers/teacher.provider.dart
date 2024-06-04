import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/utils/utils.dart';

class TeacherProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List<UserModel> _userList = [];
  bool _isLoading = false;

  List<UserModel> get userList => _userList;
  bool get isLoading => _isLoading;

  TeacherProvider() {}

  Future<void> fetchUsers(BuildContext context, String instituteId) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await _firebaseFirestore
          .collection("users")
          .where('instituteUid', isEqualTo: instituteId)
          .get();

      _userList = snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .where((user) => user.rol != 'admin')
          .toList();

      showSnackBar(context, "Usuarios actualizados", SnackBarType.success);
    } catch (e) {
      showSnackBar(
          context, "Ups! no pudimos cargar los usuarios", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTeacher(
      BuildContext context, UserModel user, String instituteId) async {
    _isLoading = true;
    notifyListeners();
    try {
      user.instituteUid = instituteId;

      await _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toMap());

      _userList.add(user);
      showSnackBar(
          context, "Usuario agregado exitosamente!", SnackBarType.success);
    } catch (e) {
      showSnackBar(
          context, "Ups! no se pudo agregar el usuario", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTeacher(BuildContext context, UserModel user) async {
    _isLoading = true;
    notifyListeners();
    try {
      print(user.uid);
      await _firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .update(user.toMap());

      int index = _userList.indexWhere((u) => u.uid == user.uid);
      if (index != -1) {
        _userList[index] = user;
      }
      showSnackBar(
          context, "Usuario actualizado exitosamente!", SnackBarType.success);
    } catch (e) {
      showSnackBar(
          context, "Ups! no se pudo actualizar el usuario", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTeacher(BuildContext context, String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseFirestore.collection("users").doc(userId).delete();

      _userList.removeWhere((user) => user.uid == userId);
      showSnackBar(context, "Usuario eliminado", SnackBarType.warning);
    } catch (e) {
      showSnackBar(
          context, "Ups! no se pudo eliminar el usuario", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assignCourseToTeacher(
      BuildContext context, String userId, CourseModel course) async {
    _isLoading = true;
    notifyListeners();
    try {
      DocumentReference userRef =
          _firebaseFirestore.collection("users").doc(userId);

      await userRef.collection("courses").doc(course.uid).set(course.toMap());

      showSnackBar(context, "Curso asignado al usuario exitosamente!",
          SnackBarType.success);
    } catch (e) {
      showSnackBar(
          context, "Ups! no se pudo asignar el curso", SnackBarType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadFile(
      BuildContext context, File file, String userId) async {
    try {
      String fileName = 'profile_pictures/$userId/profilepic';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      showSnackBar(context, "Error al subir la imagen", SnackBarType.error);
      return "";
    }
  }

  Future<String> uploadPDFFile(
      BuildContext context, File file, String userId) async {
    try {
      // Nombre del archivo en el almacenamiento de Firebase
      String fileName = 'teacher_schedules/$userId/horario.pdf';

      // Subir el archivo al almacenamiento de Firebase
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(file);

      // Esperar a que la carga se complete y obtener la URL de descarga
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      showSnackBar(context, "Archivo subido con exito!", SnackBarType.success);
      return downloadUrl;
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la carga
      showSnackBar(
          context, "Error al subir el archivo PDF", SnackBarType.error);
      return "";
    }
  }

  Future<File?> getTeacherSchedule(
      BuildContext context, String teacherUid) async {
    try {
      String pdfPath = 'teacher_schedules/$teacherUid/horario.pdf';
      File pdfFile = File('${(await Directory.systemTemp).path}/horario.pdf');

      await FirebaseStorage.instance.ref(pdfPath).writeToFile(pdfFile);

      return pdfFile;
    } catch (e) {
      showSnackBar(context, "Error al cargar el horario", SnackBarType.error);
      return null;
    }
  }
}
