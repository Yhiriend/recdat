import 'package:flutter/material.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/utils/local_notifications.dart';
import 'package:recdat/views/home.view.dart';

class TeacherNotificationsView extends StatefulWidget {
  const TeacherNotificationsView({super.key});

  @override
  State<TeacherNotificationsView> createState() =>
      _TeacherNotificationsViewState();
}

class _TeacherNotificationsViewState extends State<TeacherNotificationsView> {
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  listenToNotifications() {
    print("listening to notifications...");
    LocalNotifications.onClickNotification.stream.listen((event) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RecdatButtonAsync(
          onPressed: () async {
            LocalNotifications.showSimpleNotification(
                title: "title", body: "body", payload: "payload");
          },
          text: "Simple Notifications",
        ),
        RecdatButtonAsync(
          onPressed: () async {
            LocalNotifications.showPeriodicNotifications(
                title: "title", body: "body", payload: "payload");
          },
          text: "Periodic Not",
        ),
        RecdatButtonAsync(
          onPressed: () async {
            LocalNotifications.cancel(1);
          },
          text: "Close Periodic Not",
        ),
        RecdatButtonAsync(
          onPressed: () async {
            LocalNotifications.cancelAll();
          },
          text: "Cncel all Not",
        ),
      ],
    );
  }
}
