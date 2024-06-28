import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/notifications/providers/notification.provider.dart';
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
  late Stream<DatabaseEvent> _attendanceStream;
  late TextEditingController _filterStartDate = TextEditingController();
  late TextEditingController _filterEndDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationProvider =
          Provider.of<NotificationProvider>(context, listen: false);
      _databaseReference = FirebaseDatabase.instance
          .ref()
          .child("2024-06-27")
          .child("92d04f81-e762-495f-98ed-5f11019b60b7")
          .child('attendances');
      _attendanceStream = _databaseReference.onValue;
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    _notificationProvider.setLoading(true);
    try {
      final event = await _databaseReference.once();
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        Map<String, dynamic> attendances =
            Map<String, dynamic>.from(snapshot.value as Map);
        List<Map<String, dynamic>> attendancesList = [];
        attendances.forEach((key, value) {
          attendancesList.add(Map<String, dynamic>.from(value));
        });
        _notificationProvider.setAttendances(attendancesList);
      } else {
        _notificationProvider.setAttendances([]);
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
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
                      "Filtrar desde:",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
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
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    const Text(
                      "hasta",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
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
                return StreamBuilder<DatabaseEvent>(
                  stream: _attendanceStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('No data available'));
                    }

                    DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                    if (dataSnapshot.value != null) {
                      Map<String, dynamic> attendances =
                          Map<String, dynamic>.from(dataSnapshot.value as Map);
                      provider.setAttendances(attendances.values
                          .map((e) => Map<String, dynamic>.from(e))
                          .toList());
                    } else {
                      provider.setAttendances([]);
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.attendances.length,
                      itemBuilder: (context, index) {
                        var attendance = provider.attendances[index];
                        return ListTile(
                          title: Text(attendance['title'] ?? 'No title'),
                          subtitle: Text(attendance['body'] ?? 'No body'),
                          trailing: Text(RecdatDateUtils.formatTimeDifference(
                              attendance['createdAt'])),
                        );
                      },
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
}
