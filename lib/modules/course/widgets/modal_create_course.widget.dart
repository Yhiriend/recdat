import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_dropdown.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/utils.dart';

class ModalCreateCourseWidget extends StatelessWidget {
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseDescriptionController =
      TextEditingController();
  final TextEditingController courseAreaController = TextEditingController();
  final TextEditingController courseGradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nuevo curso',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: RecdatStyles.darkTextColor),
              ),
              const SizedBox(
                height: 20.0,
              ),
              RecdatTextfield(
                icon: Icons.book,
                placeholder: "Nombre del curso",
                controller: courseNameController,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(height: 10),
              RecdatTextfield(
                icon: Icons.text_snippet,
                placeholder: "Descripción",
                controller: courseDescriptionController,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(height: 10),
              RecdatDropdown(
                  icon: Icons.science_rounded,
                  color: RecdatStyles.textFieldLight,
                  placeholder: "Selecciona un area",
                  controller: courseAreaController,
                  options: CourseOptionsUtils.areas()),
              const SizedBox(height: 10),
              RecdatDropdown(
                  icon: Icons.numbers,
                  color: RecdatStyles.textFieldLight,
                  placeholder: "Selecciona un grado",
                  controller: courseGradeController,
                  options: CourseOptionsUtils.grades()),
              const SizedBox(
                height: 40,
              ),
              RecdatButtonAsync(
                onPressed: () async {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  final courseProvider =
                      Provider.of<CourseProvider>(context, listen: false);
                  final course = CourseModel(
                      name: courseNameController.text.trim().toUpperCase(),
                      description:
                          courseDescriptionController.text.trim().toString(),
                      grade: courseGradeController.text.trim().toString(),
                      type: courseAreaController.text.trim().toString(),
                      createdAt: RecdatDateUtils.currentDate());
                  final userUid = authProvider.user?.uid ?? "";
                  await courseProvider.addCourse(context, course, userUid);
                  await courseProvider
                      .fetchCourses(context, userUid)
                      .then((_) => Navigator.of(context).pop());
                },
                text: "Registrar curso",
              )
            ],
          ),
        ),
      ),
    );
  }
}
