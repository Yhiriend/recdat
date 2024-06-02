import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_multiselect.dart';
import 'package:recdat/shared/widgets/recdat_tagging.widget.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/utils.dart';

class EditTeacherWiew extends StatefulWidget {
  final UserModel teacher;

  final TextEditingController teacherNameController = TextEditingController();

  final TextEditingController teacherSurnameController =
      TextEditingController();
  final TextEditingController teacherSecondSurnameController =
      TextEditingController();
  final TextEditingController teacherPhoneController = TextEditingController();

  final TextEditingController teacherEmailController = TextEditingController();

  final TextEditingController teacherCoursesAsignedController =
      TextEditingController();

  final RecdatMultiselectController multiselectController =
      RecdatMultiselectController();

  EditTeacherWiew({super.key, required this.teacher});

  @override
  State<EditTeacherWiew> createState() => _EditTeacherWiewState();
}

class _EditTeacherWiewState extends State<EditTeacherWiew> {
  late UserModel _teacher;
  late bool _isActive;
  late List<CourseModel> _currentAreas = [];
  late List<CourseModel> _suggestionAreas = [];
  @override
  void initState() {
    super.initState();
    _teacher = widget.teacher;
    _isActive = widget.teacher.isActive;
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    _suggestionAreas = courseProvider.courseList;
    _currentAreas = widget.teacher.courses ?? [];
  }

  void _handleTagChange(List<CourseModel> tags) {
    setState(() {
      _currentAreas = tags;
    });
  }

  void _setTeacherValues() async {
    widget.teacherNameController.text = _teacher.name;
    widget.teacherSurnameController.text = _teacher.surname;
    widget.teacherSecondSurnameController.text = _teacher.lastSurname ?? "";
    widget.teacherPhoneController.text = _teacher.phone ?? "";
    widget.teacherEmailController.text = _teacher.email ?? "";
  }

  void _updateTeacher() async {
    final teacherProvider =
        Provider.of<TeacherProvider>(context, listen: false);
    final teacherUpdate = UserModel(
      instituteUid: _teacher.instituteUid,
      uid: _teacher.uid,
      name: widget.teacherNameController.text.trim().toUpperCase(),
      surname: widget.teacherSurnameController.text.trim().toUpperCase(),
      lastSurname:
          widget.teacherSecondSurnameController.text.trim().toUpperCase(),
      email: widget.teacherEmailController.text.trim().toUpperCase(),
      phone: widget.teacherPhoneController.text.trim(),
      rol: _teacher.rol,
      isActive: _isActive,
      createdAt: _teacher.createdAt,
      updatedAt: RecdatDateUtils.currentDate(),
      password: _teacher.password,
      courses: _currentAreas,
    );
    await teacherProvider.updateTeacher(context, teacherUpdate);
  }

  @override
  Widget build(BuildContext context) {
    _setTeacherValues();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: RecdatStyles.blueDarkColor,
        foregroundColor: RecdatStyles.whiteColor,
        title: const Text("Editando"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: RecdatStyles.opaquePrimaryBackgroundColor,
                    ),
                    child: Center(
                      child: _teacher.profilePic != null
                          ? Image.network(
                              _teacher.profilePic!,
                              width: 98,
                              height: 98,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.face_rounded,
                              size: 98,
                              color: RecdatStyles.opaquePrimaryForegroundColor,
                            ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 80,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: _isActive
                              ? RecdatStyles.activePill
                              : RecdatStyles.inactivePill,
                        ),
                        child: Center(
                            child: Text(
                          _isActive ? "activo" : "inactivo",
                          style:
                              const TextStyle(color: RecdatStyles.whiteColor),
                        )),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatTextfield(
                placeholder: "Nombre",
                controller: widget.teacherNameController,
                icon: Icons.person,
                color: RecdatStyles.textFieldLight,
                enabled: false,
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatTextfield(
                placeholder: "Apellido",
                controller: widget.teacherSurnameController,
                icon: Icons.person,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatTextfield(
                placeholder: "Segundo apellido",
                controller: widget.teacherSecondSurnameController,
                icon: Icons.person,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatTextfield(
                placeholder: "Telefono",
                controller: widget.teacherPhoneController,
                type: TextInputType.number,
                icon: Icons.phone,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatTextfield(
                placeholder: "Correo",
                controller: widget.teacherEmailController,
                icon: Icons.mail,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(
                height: 20,
              ),
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
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    _isActive = !_isActive;
                  });
                },
                text: _isActive ? "Deshabilitar" : "Habilitar",
                color: _isActive ? "warning" : "success",
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatButtonAsync(
                onPressed: () async => {},
                text: "Asignar horario",
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatButtonAsync(
                onPressed: () async => _updateTeacher(),
                text: "Guardar cambios",
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
