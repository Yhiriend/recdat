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
  bool isLoading = false;
  String? photo = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserAttendance(context);
    });
  }

  Future<void> getUserAttendance(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userLogged = authProvider.user;
    try {
      UserModel defaultUser = UserModel(
          uid: '',
          name: '',
          surname: "",
          rol: "",
          email: "",
          isActive: false,
          attendances: [],
          password: "");
      print("USER NOTIFICATIONS $userLogged");
      print("USER NEXT ${widget.userUuid}");
      await userProvider.fetchUsers(context, userLogged!.uid!).then((_) async {
        List<UserModel>? teachers = userProvider.userList;
        if (teachers != null && teachers.isNotEmpty) {
          print("TEACHERS ${teachers[0].uid}");
          print("ESTOY BUSCADO A ${widget.userUuid}");
          print("SON IGUALES? ${teachers[0].uid == widget.userUuid}");

          UserModel? user = teachers.firstWhere(
              (userFound) => userFound.uid == widget.userUuid,
              orElse: () => defaultUser);
          if (user.attendances!.isNotEmpty) {
            print("ESTOY BUSCADO Attendace ${widget.attendanceUuid}");
            print(
                "SON IGUALES? ${user.attendances![0].uuid == widget.attendanceUuid}");
            Attendance? attendance = user.attendances
                ?.firstWhere((att) => att.uuid == widget.attendanceUuid);
            print("ATTENDANCE NOTIFICATION $attendance");
            final String? image =
                await userProvider.getImageUrlByUuid(attendance!.uuid);
            setState(() {
              _attendance = attendance;
              _user = user;
              photo = image;
            });
          }
        }
      });
    } catch (e) {
      print("Error fetching user attendance: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notificación"),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black54,
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _attendance?.title ?? "SIN TITULO",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
                          "${_user?.name}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          _attendance?.createdAt.toString() ?? "Sin fecha",
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    photo != "" || photo != null
                        ? Image.network(photo!)
                        : _attendance?.filepath != ""
                            ? Icon(
                                Icons.picture_as_pdf_rounded,
                                size: 150,
                              )
                            : Text(
                                "No tiene ningun adjunto",
                                style: TextStyle(color: Colors.black45),
                              )
                  ],
                ),
              ),
      ),
    );
  }
}
