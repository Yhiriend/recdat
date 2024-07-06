import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/notifications/providers/notification.provider.dart';
import 'package:recdat/modules/notifications/views/notification_details.view.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/utils/local_notifications.dart';
import 'package:recdat/utils/utils.dart';

class AdminNotificationsView extends StatefulWidget {
  AdminNotificationsView({Key? key}) : super(key: key);

  @override
  State<AdminNotificationsView> createState() => _AdminNotificationsViewState();
}

class _AdminNotificationsViewState extends State<AdminNotificationsView> {
  late NotificationProvider _notificationProvider;
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      _listenToDatabase();
    });
  }

  void _listenToDatabase() {
    _notificationProvider.setLoading(true);

    _databaseReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<String, dynamic> allData =
            Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> allAttendances = [];

        allData.forEach((dateKey, users) {
          if (users is Map) {
            users.forEach((userKey, userValue) {
              if (userValue is Map && userValue['attendances'] != null) {
                Map<String, dynamic> attendances =
                    Map<String, dynamic>.from(userValue['attendances']);
                attendances.forEach((attendanceKey, attendanceValue) {
                  if (attendanceValue is Map) {
                    allAttendances
                        .add(Map<String, dynamic>.from(attendanceValue));
                  }
                });
              }
            });
          }
        });

        // Sort attendances by createdAt in descending order
        allAttendances.sort((a, b) {
          DateTime dateA = DateTime.parse(a['createdAt']);
          DateTime dateB = DateTime.parse(b['createdAt']);
          return dateB.compareTo(dateA); // Newest first
        });

        _notificationProvider.setAttendances(allAttendances);

        allAttendances.forEach((attendance) {
          LocalNotifications.showSimpleNotification(
            title: attendance['title'] ?? 'Nueva Asistencia',
            body: attendance['description'] ?? 'N/A',
            payload: attendance['uuid'] ?? 'Sin UUID',
          );
        });
      } else {
        _notificationProvider.setAttendances([]);
      }
      _notificationProvider.setLoading(false);
    }, onError: (error) {
      debugPrint('Error listening to database: $error');
      _notificationProvider.setAttendances([]);
      _notificationProvider.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.attendances.isEmpty) {
                  return const Center(child: Text('No attendances found'));
                }
                return ListView.builder(
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
                          print("ATTENDANCE UIUI $attendance");
                          if (authProvider.uid != attendance["createdBy"]) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationDetailsView(
                                  attendanceUuid: attendance["uuid"],
                                  userUuid: attendance["createdBy"],
                                ),
                              ),
                            );
                          }
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
          ),
        ],
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
