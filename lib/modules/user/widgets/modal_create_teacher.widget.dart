import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_multiselect.dart';
import 'package:recdat/shared/widgets/recdat_tagging.widget.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ModalCreateTeacherWidget extends StatefulWidget {
  ModalCreateTeacherWidget({super.key});

  @override
  State<ModalCreateTeacherWidget> createState() =>
      _ModalCreateTeacherWidgetState();
}

class _ModalCreateTeacherWidgetState extends State<ModalCreateTeacherWidget> {
  final TextEditingController teacherNameController = TextEditingController();

  final TextEditingController teacherSurnameController =
      TextEditingController();

  final TextEditingController teacherEmailController = TextEditingController();

  final TextEditingController teacherCoursesAsignedController =
      TextEditingController();

  final RecdatMultiselectController multiselectController =
      RecdatMultiselectController();

  late List<CourseModel> _currentAreas = [];
  late List<CourseModel> _suggestionAreas = [];

  @override
  void initState() {
    super.initState();
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    _suggestionAreas = courseProvider.courseList;
    _currentAreas = [];
  }

  void _handleTagChange(List<CourseModel> tags) {
    setState(() {
      _currentAreas = tags;
    });
    print('Current tags: $_currentAreas');
  }

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
                'Nuevo profesor',
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
                placeholder: "Nombre del profesor",
                controller: teacherNameController,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(height: 10),
              RecdatTextfield(
                icon: Icons.text_snippet,
                placeholder: "Primer apellido",
                controller: teacherSurnameController,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(height: 10),
              RecdatTextfield(
                icon: Icons.email,
                placeholder: "Correo electronico",
                controller: teacherEmailController,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(height: 10),
              TaggingWidget(
                  color: RecdatStyles.textFieldLight,
                  icon: Icons.science_rounded,
                  initialTags: _currentAreas,
                  suggestions: _suggestionAreas,
                  onChange: _handleTagChange),
              const SizedBox(
                height: 40,
              ),
              RecdatButtonAsync(
                onPressed: () async {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  final teacherProvider =
                      Provider.of<TeacherProvider>(context, listen: false);
                  final String defaultPassword =
                      teacherEmailController.text.trim().split("@")[0];
                  final teacher = UserModel(
                      name: teacherNameController.text.trim().toUpperCase(),
                      surname:
                          teacherSurnameController.text.trim().toUpperCase(),
                      email: teacherEmailController.text.trim(),
                      rol: UserRole.teacher.value,
                      createdAt: RecdatDateUtils.currentDate(),
                      password: defaultPassword,
                      uid: const Uuid().v4(),
                      courses: _currentAreas);
                  final userUid = authProvider.user?.uid ?? "";
                  await teacherProvider
                      .addTeacher(context, teacher, userUid)
                      .then((_) => Navigator.of(context).pop());
                },
                text: "Registrar profesor",
              )
            ],
          ),
        ),
      ),
    );
  }
}

final List<String> suggestions = [
  'Vue.js',
  'Javascript',
  'Open Source',
  'Flutter',
  'Dart',
  'React',
  'Angular',
  'Node.js',
];

final List<String> initialTags = [
  'Vue.js',
  'Javascript',
  'Open Source',
];

final List<Entry> data = [
  Entry(
      'cursos',
      [
        Entry('Ciencias', [
          Entry(
            'FISICA',
          ),
          Entry('BIOLOGIA'),
          Entry('MATEMATICAS'),
          Entry('QUIMICA'),
          Entry('GEOGRAFIA'),
        ]),
        Entry('Humanidades', [
          Entry('FILOSOFIA'),
          Entry('ETICA Y VALORES'),
          Entry('ARTISTICA'),
          Entry('HISTORIA'),
          Entry('LITERATURA'),
        ]),
        Entry('Tecnología', [
          Entry('INFORMATICA'),
        ]),
        Entry('Religión y Valores', [
          Entry('RELIGION'),
          Entry('COMPETENCIAS CIUDADANAS'),
        ]),
        Entry('Ed. Física y Deporte', [
          Entry('ED. FISICA Y DEPORTE'),
        ]),
      ],
      Icons.school),
];
