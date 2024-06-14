import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/modules/course/course.model.dart';
import 'package:recdat/modules/course/providers/course.provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_file_picker.dart';
import 'package:recdat/shared/widgets/recdat_multiselect.dart';
import 'package:recdat/shared/widgets/recdat_textarea.dart';
import 'package:recdat/shared/widgets/recdat_textfield.dart';
import 'package:recdat/utils/utils.dart';
import 'package:uuid/uuid.dart';

class ModalCreateAttendanceWidget extends StatefulWidget {
  ModalCreateAttendanceWidget({super.key});

  @override
  State<ModalCreateAttendanceWidget> createState() =>
      _ModalCreateAttendanceWidgetState();
}

class _ModalCreateAttendanceWidgetState
    extends State<ModalCreateAttendanceWidget> {
  final TextEditingController attendanceDescriptionController =
      TextEditingController();

  final TextEditingController teacherSurnameController =
      TextEditingController();

  final TextEditingController attendanceTitleController =
      TextEditingController();

  final TextEditingController teacherCoursesAsignedController =
      TextEditingController();

  final RecdatMultiselectController multiselectController =
      RecdatMultiselectController();

  late List<CourseModel> _currentAreas = [];
  late List<CourseModel> _suggestionAreas = [];
  File? _selectedFile;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    _suggestionAreas = courseProvider.courseList;
    _currentAreas = [];
  }

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'png', 'jpeg'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  _onFileChange(File file) {
    setState(() {
      _selectedFile = file;
    });
  }

  void _handleTagChange(List<CourseModel> tags) {
    setState(() {
      _currentAreas = tags;
    });
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
                'Registrar inasistencia',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: RecdatStyles.darkTextColor),
              ),
              const SizedBox(height: 20),
              RecdatTextfield(
                icon: Icons.email,
                placeholder: "Titulo",
                controller: attendanceTitleController,
                color: RecdatStyles.textFieldLight,
              ),
              const SizedBox(height: 20),
              RecdatTextarea(
                icon: Icons.email,
                placeholder: "Descripcion",
                controller: attendanceDescriptionController,
                color: RecdatStyles.textFieldLight,
              ),
              RecdatFilePicker(
                defaultIcon: Icons.image,
                visualiceText: "",
                fileType: FileType.custom,
                allowedExtensions: const ['pdf', 'jpg', 'png', 'jpeg'],
                onChanged: (File? file) {
                  if (file != null) {
                    _onFileChange(file);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              RecdatButtonAsync(
                onPressed: () async {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  final teacherProvider =
                      Provider.of<TeacherProvider>(context, listen: false);

                  Attendance attendance = Attendance(
                      uuid: const Uuid().v4(),
                      title:
                          attendanceTitleController.text.trim().toUpperCase(),
                      description: attendanceDescriptionController.text.trim(),
                      createdAt: RecdatDateUtils.currentDate(),
                      filepath: "",
                      type: "NON-ATTENDANCE");
                  final userUid = authProvider.user?.uid ?? "";
                  if (_selectedFile != null) {
                    await teacherProvider
                        .uploadAttendanceFile(context, _selectedFile!, userUid)
                        .then((value) {
                      attendance.filepath = value;
                    });
                  }
                  await teacherProvider
                      .addAttendance(context, userUid, attendance)
                      .then((_) {
                    Navigator.of(context).pop();
                  });
                },
                text: "Registrar",
              )
            ],
          ),
        ),
      ),
    );
  }
}
