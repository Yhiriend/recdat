import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool _isLoading = false;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> createAttendance(
      {required String userUid,
      required String date,
      required String title,
      required String body,
      required String createdAt,
      required String uuid}) async {
    setLoading(true);

    Map<String, dynamic> attendanceData = {
      "title": title,
      "body": body,
      "createdAt": createdAt,
      "uuid": uuid
    };

    try {
      await _databaseReference
          .child(date)
          .child(userUid)
          .child('attendances')
          .child(uuid)
          .set(attendanceData);
    } catch (e) {
      // Handle the error
      debugPrint('Error creating attendance: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> getAttendances(
      String userUid, String date) async {
    setLoading(true);
    List<Map<String, dynamic>> attendancesList = [];

    try {
      DatabaseEvent event = await _databaseReference
          .child(date)
          .child(userUid)
          .child('attendances')
          .once();

      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<String, dynamic> attendances =
            Map<String, dynamic>.from(snapshot.value as Map);
        attendances.forEach((key, value) {
          attendancesList.add(Map<String, dynamic>.from(value));
        });
      }
    } catch (e) {
      // Handle the error
      debugPrint('Error reading attendances: $e');
    } finally {
      setLoading(false);
    }

    return attendancesList;
  }

  Future<void> deleteAttendance(
      String userUid, String date, String uuid) async {
    setLoading(true);

    try {
      await _databaseReference
          .child(date)
          .child(userUid)
          .child('attendances')
          .child(uuid)
          .remove();
    } catch (e) {
      // Handle the error
      debugPrint('Error deleting attendance: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateAttendance(
      {required String userUid,
      required String date,
      required String uuid,
      required Map<String, dynamic> updatedData}) async {
    setLoading(true);

    try {
      await _databaseReference
          .child(date)
          .child(userUid)
          .child('attendances')
          .child(uuid)
          .update(updatedData);
    } catch (e) {
      // Handle the error
      debugPrint('Error updating attendance: $e');
    } finally {
      setLoading(false);
    }
  }
}
