import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/modules/course/widgets/card_courses.widget.dart';
import 'package:recdat/modules/course/widgets/modal_create_course.widget.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/utils/utils.dart';

class CoursesView extends StatefulWidget {
  const CoursesView({super.key});

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourses();
    });
  }

  void _fetchCourses() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final userUid = authProvider.user?.uid;
    if (userUid != null) {
      await courseProvider.fetchCourses(context, userUid).then((_) {
        showSnackBar(context, "Cursos actualizados", SnackBarType.success);
      });
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
            "Cursos",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Consumer<CourseProvider>(
            builder: (context, courseProvider, child) {
              if (courseProvider.isLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: RecdatStyles.whiteColor,
                ));
              }

              if (courseProvider.courseList.isEmpty) {
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
                itemCount: courseProvider.courseList.length,
                itemBuilder: (context, index) {
                  final course = courseProvider.courseList[index];
                  return CardCourseWidget(
                    title: course.name ?? '',
                    description: course.description ?? '',
                    courseType: course.type ?? '',
                    grade: course.grade ?? '',
                    courseUid: course.uid ?? '',
                    createdAt: course.createdAt ?? '',
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
