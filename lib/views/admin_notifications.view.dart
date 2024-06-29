import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/notifications/providers/notification.provider.dart';
import 'package:recdat/modules/notifications/views/notification_details.view.dart';
import 'package:recdat/shared/widgets/recdat_input_date.dart';
import 'package:recdat/utils/utils.dart';

class AdminNotificationsView extends StatefulWidget {
  AdminNotificationsView({Key? key}) : super(key: key);

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

class _AdminNotificationsViewState extends State<AdminNotificationsView> {
  late NotificationProvider _notificationProvider;
  late DatabaseReference _databaseReference;
  late TextEditingController _filterStartDate;
  late TextEditingController _filterEndDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now().toUtc().subtract(const Duration(hours: 5));
    String today = DateFormat('yyyy-MM-dd').format(now);

    _filterStartDate = TextEditingController(text: today);
    _filterEndDate = TextEditingController(text: today);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      _filterAttendancesByDate();
    });
  }

  Future<void> _filterAttendancesByDate() async {
    final startDate = _filterStartDate.text;
    final endDate = _filterEndDate.text;

    if (startDate.isEmpty || endDate.isEmpty) {
      return;
    }

    final startDateTime =
        DateTime.parse(startDate).toUtc().subtract(const Duration(hours: 5));
    final endDateTime = DateTime.parse(endDate)
        .toUtc()
        .add(const Duration(days: 1))
        .subtract(const Duration(hours: 5));

    _notificationProvider.setLoading(true);

    try {
      final snapshot = await FirebaseDatabase.instance.ref().get();
      if (snapshot.value != null) {
        Map<String, dynamic> allData =
            Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> filteredList = [];

        allData.forEach((dateKey, users) {
          if (users is Map) {
            DateTime date = DateTime.parse(dateKey);
            if (date.isAfter(startDateTime) && date.isBefore(endDateTime)) {
              users.forEach((userKey, userValue) {
                if (userValue is Map && userValue['attendances'] != null) {
                  Map<String, dynamic> attendances =
                      Map<String, dynamic>.from(userValue['attendances']);
                  attendances.forEach((attendanceKey, attendanceValue) {
                    if (attendanceValue is Map &&
                        attendanceValue['createdAt'] != null) {
                      final createdAt =
                          DateTime.parse(attendanceValue['createdAt']);
                      if (createdAt.isAfter(startDateTime) &&
                          createdAt.isBefore(endDateTime)) {
                        filteredList
                            .add(Map<String, dynamic>.from(attendanceValue));
                      }
                    }
                  });
                }
              });
            }
          }
        });

        _notificationProvider.setAttendances(filteredList);
      } else {
        _notificationProvider.setAttendances([]);
      }
    } catch (e) {
      debugPrint('Error filtering data: $e');
      _notificationProvider.setAttendances([]);
    } finally {
      _notificationProvider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(115, 0, 0, 0),
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Desde",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Expanded(
                      child: RecdatInputDate(
                        placeholder: "Fecha",
                        controller: _filterStartDate,
                        onChanged: (date) {
                          // Handle date filter change if needed
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    const Text(
                      "Hasta",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.015,
                    ),
                    Expanded(
                      child: RecdatInputDate(
                        placeholder: "Fecha",
                        controller: _filterEndDate,
                        onChanged: (date) {
                          // Handle date filter change if needed
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _filterAttendancesByDate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Consumer<NotificationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (provider.attendances.isEmpty) {
                  return Center(child: Text('No attendances found'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: provider.attendances.length,
                  itemBuilder: (context, index) {
                    var attendance = provider.attendances[index];
                    return Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(28, 0, 0, 0),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationDetailsView(
                                attendanceUuid: attendance["uuid"],
                                userUuid: attendance["createdBy"],
                              ),
                            ),
                          );
                        },
                        title: Text(attendance['title'] ?? 'No title'),
                        subtitle: Text(_truncateText(attendance['body'], 10)),
                        trailing: Text(RecdatDateUtils.formatTimeDifference(
                            attendance['createdAt'])),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    if (text == "") {
      return "Sin descripción";
    }
    return '${words.sublist(0, maxWords).join(' ')}...';
  }
}
