import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/modules/user/views/edit_teacher.view.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/utils.dart';
import 'package:recdat/views/pdf_viewer.view.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late UserModel? _teacher;
  late bool _isActive;
  late List<CourseModel> _courses;

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _userSurnameController = TextEditingController();
  final TextEditingController _userSecondSurnameController =
      TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();

  final TextEditingController _userEmailController = TextEditingController();

  File? _selectedImage;
  dynamic _profilePic;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _teacher = authProvider.user;
    _setTeacherValues(_teacher!);
  }

  void _setTeacherValues(UserModel user) async {
    _userNameController.text = user.name;
    _userSurnameController.text = user.surname;
    _userSecondSurnameController.text = user.lastSurname!;
    _userPhoneController.text = user.phone ?? "";
    _userEmailController.text = user.email ?? "";
    _isActive = user.isActive;
    _courses = user.courses ?? [];
  }

  void _openFilePicker() async {
    dynamic result = await FilePicker.platform
        .pickFiles(type: FileType.any, allowMultiple: false);

    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  void _updateUser() async {
    final teacherProvider =
        Provider.of<TeacherProvider>(context, listen: false);
    if (_selectedImage != null) {
      _profilePic = await teacherProvider.uploadFile(
          context, _selectedImage!, _teacher!.uid!);
    }
    final teacherUpdate = UserModel(
        instituteUid: _teacher!.instituteUid,
        uid: _teacher!.uid,
        name: _teacher!.name,
        surname: _teacher!.surname,
        lastSurname: _teacher!.lastSurname,
        email: _userEmailController.text.trim().toUpperCase(),
        phone: _userPhoneController.text.trim(),
        rol: _teacher!.rol,
        isActive: _teacher!.isActive,
        createdAt: _teacher!.createdAt,
        updatedAt: RecdatDateUtils.currentDate(),
        password: _teacher!.password,
        courses: _teacher!.courses,
        profilePic: _profilePic);
    await teacherProvider.updateTeacher(context, teacherUpdate);
  }

  Future<File?> _getSchedulePDF() async {
    final teacherProvider =
        Provider.of<TeacherProvider>(context, listen: false);
    return await teacherProvider.getTeacherSchedule(context, _teacher!.uid!);
  }

  Future<void> _openSchedule() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerView(pdfFuture: _getSchedulePDF()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: RecdatStyles.opaquePrimaryBackgroundColor,
                    image: _teacher!.profilePic != null
                        ? DecorationImage(
                            image: NetworkImage(_teacher!.profilePic!),
                            fit: BoxFit.cover,
                          )
                        : _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
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
                        style: const TextStyle(color: RecdatStyles.whiteColor),
                      )),
                    )),
                Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: RecdatStyles.defaultColor,
                      ),
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          _openFilePicker();
                        },
                        child: const Icon(
                          Icons.edit,
                          color: RecdatStyles.segundaryButtonColor,
                        ),
                      )),
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Nombre",
              controller: _userNameController,
              icon: Icons.person,
              color: RecdatStyles.textFieldLight,
              enabled: false,
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Apellido",
              controller: _userSurnameController,
              icon: Icons.person,
              color: RecdatStyles.textFieldLight,
              enabled: false,
            ),
            const SizedBox(
              height: 20,
            ),
            _teacher?.lastSurname != ""
                ? RecdatTextfield(
                    placeholder: "Segundo apellido",
                    controller: _userSecondSurnameController,
                    icon: Icons.person,
                    color: RecdatStyles.textFieldLight,
                    enabled: false,
                  )
                : const SizedBox(
                    height: 0.0,
                  ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Telefono",
              controller: _userPhoneController,
              type: TextInputType.number,
              icon: Icons.phone,
              color: RecdatStyles.textFieldLight,
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Correo",
              controller: _userEmailController,
              icon: Icons.mail,
              color: RecdatStyles.textFieldLight,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: _courses.map((course) {
                return Chip(
                  label: Text(course.name ?? ''),
                  onDeleted: () => {},
                  deleteIcon: const Icon(Icons.numbers),
                );
              }).toList(),
            ),
            const SizedBox(
              height: 40,
            ),
            RecdatButtonAsync(
              onPressed: () async => _openSchedule(),
              text: "Ver horario",
              color: "success",
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatButtonAsync(
              onPressed: () async => _updateUser(),
              text: "Guardar cambios",
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}