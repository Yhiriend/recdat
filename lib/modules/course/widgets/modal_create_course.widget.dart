import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_dropdown.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';

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
                  options: const [
                    'INFORMATICA',
                    'FISICA',
                    'BIOLOGIA',
                    'MATEMATICAS',
                    'QUIMICA',
                    'INFORMATICA2',
                    'FISICA2',
                    'BIOLOGIA2',
                    'MATEMATICAS2',
                    'QUIMICA2'
                  ]),
              const SizedBox(height: 10),
              RecdatDropdown(
                  icon: Icons.numbers,
                  color: RecdatStyles.textFieldLight,
                  placeholder: "Selecciona un grado",
                  controller: courseGradeController,
                  options: const [
                    'VI (6º grado)',
                    'VII (7º grado)',
                    'VIII (8º grado)',
                    'IX (9º grado)',
                    'X (10º grado)',
                    'XI (11º grado)',
                  ]),
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
                      name: courseNameController.text.trim().toString(),
                      description:
                          courseDescriptionController.text.trim().toString(),
                      grade: courseGradeController.text.trim().toString(),
                      type: courseAreaController.text.trim().toString(),
                      createdAt: "");
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
