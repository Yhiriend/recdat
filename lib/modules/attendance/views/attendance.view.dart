import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/modules/attendance/widgets/card_attendance.widget.dart';
import 'package:recdat/modules/attendance/widgets/modal_create_attendance.widget.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    print("USER ATTENDANCES: ${authProvider.user?.attendances}");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: RecdatStyles.whiteColor,
              ));
            }

            if (authProvider.user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                          RecdatStyles.darkTextColor, BlendMode.srcIn),
                      child: Image.asset('assets/images/book.png'),
                    ),
                    const Text(
                      "No hay cursos",
                      style: TextStyle(
                          color: RecdatStyles.darkTextColor, fontSize: 30),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: authProvider.user?.attendances?.length,
              itemBuilder: (context, index) {
                final attendance = authProvider.user?.attendances![index];
                return CardAttendanceWidget(
                  isAttendance: attendance?.type == "ATTENDANCE",
                  attendance: attendance!,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
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
