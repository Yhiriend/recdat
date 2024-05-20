import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/modules/course/widgets/card_courses.widget.dart';
import 'package:recdat/modules/course/widgets/modal_create_course.widget.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/modules/user/widgets/card_teacher.widget.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class TeachersView extends StatefulWidget {
  const TeachersView({super.key});

  @override
  State<TeachersView> createState() => _TeachersViewState();
}

class _TeachersViewState extends State<TeachersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTeachers();
    });
  }

  void _fetchTeachers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final teacherProvider =
        Provider.of<TeacherProvider>(context, listen: false);
    final userUid = authProvider.user?.uid;
    if (userUid != null) {
      await teacherProvider.fetchUsers(context, userUid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: RecdatStyles.backPageWhiteColor,
        appBar: AppBar(
          backgroundColor: RecdatStyles.blueDarkColor,
          foregroundColor: RecdatStyles.defaultTextColor,
          title: const Text(
            "Profesores",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Consumer<TeacherProvider>(
            builder: (context, teacherProvider, child) {
              if (teacherProvider.isLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: RecdatStyles.whiteColor,
                ));
              }

              if (teacherProvider.userList.isEmpty) {
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
                        "No hay profesores",
                        style: TextStyle(
                            color: RecdatStyles.darkTextColor, fontSize: 30),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: teacherProvider.userList.length,
                itemBuilder: (context, index) {
                  final teacher = teacherProvider.userList[index];
                  return CardTeacherWidget(
                    name: teacher.name ?? '',
                    surname: teacher.surname ?? '',
                    email: teacher.email ?? '',
                    teacherUid: teacher.uid ?? '',
                    totalCourses: 5,
                    createdAt: teacher.createdAt ?? '',
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
          onPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ModalCreateCourseWidget();
              },
            );
          },
        ),
      ),
    );
  }
}
