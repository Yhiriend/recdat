import 'package:flutter/material.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_multiselect.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';

class EditTeacherWiew extends StatefulWidget {
  final UserModel teacher;

  final TextEditingController teacherNameController = TextEditingController();
  final TextEditingController teacherSecondNameController =
      TextEditingController();

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
  @override
  void initState() {
    super.initState();
    _teacher = widget.teacher;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Editando"),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Nombre",
              controller: widget.teacherNameController,
              icon: Icons.person,
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Segundo nombre",
              controller: widget.teacherSecondNameController,
              icon: Icons.person,
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Apellido",
              controller: widget.teacherSurnameController,
              icon: Icons.person,
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Segundo apellido",
              controller: widget.teacherSecondSurnameController,
              icon: Icons.person,
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Telefono",
              controller: widget.teacherPhoneController,
              icon: Icons.phone,
            ),
            const SizedBox(
              height: 20,
            ),
            RecdatTextfield(
              placeholder: "Correo",
              controller: widget.teacherEmailController,
              icon: Icons.mail,
            )
          ],
        ),
      ),
    ));
  }
}
