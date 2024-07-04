import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';

class PunctualityPage extends StatefulWidget {
  @override
  _PunctualityPageState createState() => _PunctualityPageState();
}

class _PunctualityPageState extends State<PunctualityPage> {
  bool isLoading = false;
  String selectedTeacherId = '';
  List<Map<String, dynamic>> _punctuality = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      fetchUsers();
    });
  }

  Future<void> fetchUsers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUsers(context, authProvider.user!.uid!);
  }

  Future<void> fetchPunctualityData(String teacherId) async {
    setState(() {
      isLoading = true;
    });

    try {
      _punctuality = await calculatePunctualityData(teacherId);
    } catch (e) {
      print("Error fetching punctuality data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> calculatePunctualityData(
      String teacherId) async {
    List<Map<String, dynamic>> punctualityData = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final selectedTeacher =
          userProvider.userList.firstWhere((user) => user.uid == teacherId);

      print("SELECTED TEACHER $selectedTeacher");

      List<dynamic> attendances = selectedTeacher.attendances ?? [];
      List<dynamic> entryAssignments = selectedTeacher.entryAssigments ?? [];

      DateTime now = DateTime.now();
      DateTime fifteenDaysAgo = now.subtract(Duration(days: 15));

      for (var attendance in attendances) {
        print("ATTENDANCES SELECTED $attendance");
        DateTime createdAt = DateTime.parse(attendance.createdAt.toString());
        if (createdAt.isAfter(fifteenDaysAgo)) {
          String dayOfWeek = DateFormat('EEEE').format(createdAt);
          String attendanceTimeStr = DateFormat('jm').format(createdAt);
          DateTime attendanceTime = DateFormat('jm').parse(attendanceTimeStr);

          print("DAY OF WEEK $dayOfWeek");

          for (var entry in entryAssignments) {
            print("ASSIGMENTS SELECTED $entry");
            if (entry.day == dayOfWeek) {
              String entryTimeStr = entry.hour.trim();
              print("ASSIGMENTS entryTimeStr $entryTimeStr");
              if (entryTimeStr.isNotEmpty) {
                DateTime entryTime = DateFormat('H:mm').parse(entryTimeStr);

                int delayMinutes =
                    attendanceTime.difference(entryTime).inMinutes;
                if (delayMinutes < 0) {
                  delayMinutes = 0;
                }

                punctualityData.add({
                  'date': createdAt.toIso8601String(),
                  'average_delay': delayMinutes,
                });
                print("PUNCTUALITY $punctualityData");
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error calculating punctuality data: $e");
    }

    return punctualityData;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        if (userProvider.isLoading)
          CircularProgressIndicator()
        else
          DropdownButton<String>(
            value: selectedTeacherId.isEmpty ? null : selectedTeacherId,
            hint: Text('Select a Teacher'),
            onChanged: (String? newValue) {
              setState(() {
                selectedTeacherId = newValue!;
                fetchPunctualityData(selectedTeacherId);
              });
            },
            items:
                userProvider.userList.map<DropdownMenuItem<String>>((teacher) {
              return DropdownMenuItem<String>(
                value: teacher.uid,
                child: Text(teacher.name),
              );
            }).toList(),
          ),
        if (isLoading)
          CircularProgressIndicator()
        else
          Expanded(
            child: ListView.builder(
              itemCount: _punctuality.length,
              itemBuilder: (context, index) {
                final entry = _punctuality[index];
                final date = DateTime.parse(entry['date']);
                final formattedDate = DateFormat('dd MMM yyyy').format(date);
                final averageDelay = entry['average_delay'];

                return ListTile(
                  title: Text(formattedDate),
                  subtitle: Text('Average Delay: $averageDelay minutes'),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                );
              },
            ),
          ),
      ],
    );
  }
}
