import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/modules/user/widgets/card_teacher.widget.dart';
import 'package:recdat/modules/user/widgets/modal_create_teacher.widget.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/utils/routes.dart';

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
      _fetchCourses();
    });
  }

  void _fetchCourses() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userUid = authProvider.user?.uid;
    await courseProvider.fetchCourses(context, userUid!);
  }

  void _fetchTeachers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final teacherProvider = Provider.of<UserProvider>(context, listen: false);
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
          child: Consumer<UserProvider>(
            builder: (context, teacherProvider, child) {
              if (teacherProvider.isLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: RecdatStyles.darkTextColor,
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
                  return CardTeacherWidget(teacher: teacher);
                },
              );
            },
          ),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.view_list,
          backgroundColor: RecdatStyles.blueDarkColor,
          foregroundColor: RecdatStyles.defaultTextColor,
          overlayColor: RecdatStyles.blueDarkColor,
          overlayOpacity: 0.4,
          spacing: 8,
          children: [
            SpeedDialChild(
              foregroundColor: RecdatStyles.blueDarkColor,
              child: const Icon(Icons.person_add_alt_rounded),
              label: "Agregar profesor",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModalCreateTeacherWidget();
                  },
                );
              },
            ),
            SpeedDialChild(
                foregroundColor: RecdatStyles.blueDarkColor,
                child: const Icon(Icons.assignment_add),
                label: "Asignacion de horarios",
                onTap: () {
                  Navigator.pushNamed(context, RecdatRoutes.scheduleAssigment);
                })
          ],
        ),
      ),
    );
  }
}
