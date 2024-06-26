import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_dropdown.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/utils.dart';
import 'package:recdat/views/pdf_viewer.view.dart';

class SettingsView extends StatefulWidget {
  SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late UserModel? _userLogged;
  late bool _isActive;
  late List<CourseModel> _courses;

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _userSurnameController = TextEditingController();
  final TextEditingController _userSecondSurnameController =
      TextEditingController();
  final TextEditingController _userPhoneController = TextEditingController();

  final TextEditingController _userEmailController = TextEditingController();

  final TextEditingController _userPasswordController = TextEditingController();

  final TextEditingController _userSecurityQuestionController =
      TextEditingController();

  final TextEditingController _userSecurityAnswerController =
      TextEditingController();

  File? _selectedImage;
  dynamic _profilePic;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _userLogged = authProvider.user;
    _setUserValues(_userLogged!);
  }

  void _setUserValues(UserModel user) async {
    _userNameController.text = user.name;
    _userSurnameController.text = user.surname;
    _userSecondSurnameController.text = user.lastSurname ?? "";
    _userPhoneController.text = user.phone ?? "";
    _userEmailController.text = user.email ?? "";
    _isActive = user.isActive;
    _courses = user.courses ?? [];
    _userSecurityQuestionController.text = user.question ?? "";
    _userSecurityAnswerController.text = user.answer ?? "";
    _userPasswordController.text = user.password;
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_selectedImage != null) {
      _profilePic = await userProvider.uploadFile(
          context, _selectedImage!, _userLogged!.uid!);
    }
    final userUpdated = UserModel(
        instituteUid: _userLogged!.instituteUid,
        uid: _userLogged!.uid,
        name: _userLogged!.name,
        surname: _userLogged!.surname,
        lastSurname: _userLogged!.lastSurname,
        email: _userEmailController.text.trim().toLowerCase(),
        phone: _userPhoneController.text.trim(),
        rol: _userLogged!.rol,
        isActive: _userLogged!.isActive,
        createdAt: _userLogged!.createdAt,
        updatedAt: RecdatDateUtils.currentDate(),
        password: _userPasswordController.text.trim(),
        courses: _userLogged!.courses,
        question: _userSecurityQuestionController.text.trim().toLowerCase(),
        answer: _userSecurityAnswerController.text.trim().toLowerCase(),
        profilePic: _profilePic);
    await userProvider.updateTeacher(context, userUpdated);
  }

  Future<File?> _getSchedulePDF() async {
    final teacherProvider = Provider.of<UserProvider>(context, listen: false);
    return await teacherProvider.getTeacherSchedule(context, _userLogged!.uid!);
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
                      color: RecdatStyles.backgroundLoader,
                      image: _userLogged?.profilePic == null ||
                              _userLogged?.profilePic == ""
                          ? _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/default_avatar.jpg'),
                                  fit: BoxFit.contain,
                                )
                          : DecorationImage(
                              image: NetworkImage(_userLogged!.profilePic!),
                              fit: BoxFit.cover,
                            )),
                ),
                if (_userLogged?.rol == UserRole.teacher.value)
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
                      )),
                Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 35,
                      height: 35,
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
                          color: RecdatStyles.blueDarkColor,
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
              enabled: (_userLogged?.rol == UserRole.admin.value),
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Apellido",
              controller: _userSurnameController,
              icon: Icons.person,
              color: RecdatStyles.textFieldLight,
              enabled: (_userLogged?.rol == UserRole.admin.value),
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Segundo apellido",
              controller: _userSecondSurnameController,
              icon: Icons.person,
              color: RecdatStyles.textFieldLight,
              enabled: (_userLogged?.rol == UserRole.admin.value),
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
            const SizedBox(
              height: 20,
            ),
            if (_userLogged?.rol == UserRole.teacher.value)
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Cursos asignados:",
                  textAlign: TextAlign.left,
                ),
              ),
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
              height: 20,
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                "El siguiente campo corresponde a la contraseña, si la cambias te recomendamos cerrar y volver a iniciar sesión",
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RecdatTextfield(
              placeholder: "Contraseña",
              controller: _userPasswordController,
              icon: Icons.lock,
              color: RecdatStyles.textFieldLight,
              isPassword: true,
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: double.infinity,
              child: Text(
                "Para registro manual llena los siguientes campos",
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RecdatDropdown(
                color: RecdatStyles.textFieldLight,
                placeholder: "Pregunta de seguridad",
                controller: _userSecurityQuestionController,
                options: securityQuestions),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Respuesta de seguridad",
              controller: _userSecurityAnswerController,
              icon: Icons.lock_person,
              color: RecdatStyles.textFieldLight,
              enabled: true,
            ),
            if (_userLogged?.rol == UserRole.teacher.value)
              const SizedBox(
                height: 40,
              ),
            if (_userLogged?.rol == UserRole.teacher.value)
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

  List<DropdownOption> securityQuestions = [
    DropdownOption(
        value: 'color_favorito', label: '¿Cuál es tu color favorito?'),
    DropdownOption(
        value: 'nombre_mascota',
        label: '¿Cuál es el nombre de tu primera mascota?'),
    DropdownOption(
        value: 'ciudad_nacimiento', label: '¿En qué ciudad naciste?'),
    DropdownOption(
        value: 'escuela_primaria',
        label: '¿Cuál fue el nombre de tu escuela primaria?'),
    DropdownOption(
        value: 'primer_coche', label: '¿Cuál fue la marca de tu primer coche?'),
    DropdownOption(
        value: 'comida_favorita', label: '¿Cuál es tu comida favorita?'),
    DropdownOption(
        value: 'nombre_padre', label: '¿Cuál es el nombre de tu padre?'),
    DropdownOption(
        value: 'nombre_madre', label: '¿Cuál es el nombre de tu madre?'),
    DropdownOption(
        value: 'primer_trabajo', label: '¿Cuál fue tu primer trabajo?'),
    DropdownOption(
        value: 'mejor_amigo',
        label: '¿Cuál es el nombre de tu mejor amigo de la infancia?'),
    DropdownOption(
        value: 'libro_favorito', label: '¿Cuál es tu libro favorito?')
  ];
}
