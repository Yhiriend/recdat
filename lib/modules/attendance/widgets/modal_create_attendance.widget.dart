import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_file_picker.dart';
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

final databaseReference = FirebaseDatabase.instance.ref();

class _ModalCreateAttendanceWidgetState
    extends State<ModalCreateAttendanceWidget> {
  final TextEditingController attendanceDescriptionController =
      TextEditingController();

  final TextEditingController attendanceTitleController =
      TextEditingController();

  File? _selectedFile;
  String? _fileName;

  @override
  void initState() {
    super.initState();
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
                      Provider.of<UserProvider>(context, listen: false);

                  Attendance attendance = Attendance(
                      canEdit: true,
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
                      .then((_) async {
                    await authProvider.syncUserDataByUid(context, userUid);

                    Map<String, dynamic> attendanceData = {
                      "title": attendance.title,
                      "body": attendance.description,
                      "createdAt": attendance.createdAt,
                      "uuid": attendance.uuid
                    };
                    databaseReference
                        .child(attendance.createdAt.split(" ")[0])
                        .child(userUid)
                        .child('attendances')
                        .child(attendance.uuid)
                        .set(attendanceData);
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
