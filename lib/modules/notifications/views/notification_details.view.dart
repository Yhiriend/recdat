import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';

class NotificationDetailsView extends StatefulWidget {
  final String attendanceUuid;
  final String userUuid;
  NotificationDetailsView(
      {super.key, required this.attendanceUuid, required this.userUuid});

  @override
  State<NotificationDetailsView> createState() =>
      _NotificationDetailsViewState();
}

class _NotificationDetailsViewState extends State<NotificationDetailsView> {
  Attendance? _attendance;
  UserModel? _user;
  @override
  void initState() {
    super.initState();
    getUserAttendance(context);
  }

  Future<void> getUserAttendance(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userLogged = authProvider.user;
    try {
      await userProvider.fetchUsers(context, userLogged!.uid!);
      UserModel user = userProvider.userList
          .firstWhere((user) => user.uid == widget.userUuid);

      Attendance? attendance = user.attendances
          ?.firstWhere((att) => att.uuid == widget.attendanceUuid);
      setState(() {
        _attendance = attendance;
        _user = user;
      });
    } catch (e) {
      print("Error fetching user attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notificación"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _attendance?.title ?? "SIN TITULO",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                _attendance?.description ?? "Sin descripcion",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _user?.name ?? "Sin nombre",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    _attendance?.createdAt ?? "Sin fecha",
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              Icon(
                Icons.picture_as_pdf_rounded,
                size: 150,
              )
            ],
          ),
        ),
      ),
    );
  }
}
