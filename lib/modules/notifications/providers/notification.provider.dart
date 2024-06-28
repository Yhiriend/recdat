import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _attendances = [];

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get attendances => _attendances;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setAttendances(List<Map<String, dynamic>> value) async {
    try {
      _attendances = value;
      setLoading(false);
    } catch (e) {
      debugPrint('Error creating attendance: $e');
    }
  }

  Future<void> createAttendance({
    required String userUid,
    required String date,
    required String title,
    required String body,
    required String createdAt,
    required String uuid,
  }) async {
    setLoading(true);

    Map<String, dynamic> attendanceData = {
      "title": title,
      "body": body,
      "createdAt": createdAt,
      "uuid": uuid,
    };

    try {
      await _databaseReference
          .child(date)
          .child(userUid)
          .child('attendances')
          .child(uuid)
          .set(attendanceData);
    } catch (e) {
      debugPrint('Error creating attendance: $e');
    } finally {
      setLoading(false);
    }
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
      debugPrint('Error deleting attendance: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateAttendance({
    required String userUid,
    required String date,
    required String uuid,
    required Map<String, dynamic> updatedData,
  }) async {
    setLoading(true);

    try {
      await _databaseReference
          .child(date)
          .child(userUid)
          .child('attendances')
          .child(uuid)
          .update(updatedData);
    } catch (e) {
      debugPrint('Error updating attendance: $e');
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
      print("ATTENDANCES: $attendancesList");
    } catch (e) {
      debugPrint('Error reading attendances: $e');
    } finally {
      setLoading(false);
    }

    return attendancesList;
  }

  Future<List<Map<String, dynamic>>> getAttendancesBetweenDates(
      String userUid, String startDate, String endDate) async {
    setLoading(true);
    List<Map<String, dynamic>> attendancesList = [];

    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<String, dynamic> dates =
            Map<String, dynamic>.from(snapshot.value as Map);

        dates.forEach((date, users) {
          if (date.compareTo(startDate) >= 0 && date.compareTo(endDate) <= 0) {
            if (users[userUid] != null) {
              Map<String, dynamic> attendances = Map<String, dynamic>.from(
                  users[userUid]['attendances'] as Map);
              attendances.forEach((key, value) {
                attendancesList.add(Map<String, dynamic>.from(value));
              });
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error reading attendances: $e');
    } finally {
      setLoading(false);
    }

    return attendancesList;
  }
}
