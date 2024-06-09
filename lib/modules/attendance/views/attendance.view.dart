import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:recdat/modules/attendance/widgets/modal_create_attendance.widget.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        icon: Icons.plus_one,
        backgroundColor: RecdatStyles.blueDarkColor,
        foregroundColor: RecdatStyles.defaultTextColor,
        overlayColor: RecdatStyles.blueDarkColor,
        overlayOpacity: 0.4,
        spacing: 8,
        onPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ModalCreateAttendanceWidget();
            },
          );
        },
      ),
    );
  }
}
