import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/shared/widgets/recdat_dropdown.dart';
import 'package:recdat/shared/widgets/recdat_file_picker.dart';
import 'package:recdat/utils/utils.dart';

class ScheduleAssigmentView extends StatefulWidget {
  final TextEditingController teacherSelectionController =
      TextEditingController();

  ScheduleAssigmentView({super.key});

  @override
  State<ScheduleAssigmentView> createState() => _ScheduleAssigmentViewState();
}

class _ScheduleAssigmentViewState extends State<ScheduleAssigmentView> {
  List<DropdownOption>? _teachers;
  bool _isLoading = true;
  File? _schedule;
  DropdownOption? _teacherSelected;

  @override
  void initState() {
    super.initState();
    _teachers = [];
    // Programar la tarea para que se ejecute después de que se haya construido el cuadro actual
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchAndAssignTeachers();
    });
  }

  void _fetchAndAssignTeachers() async {
    List<DropdownOption> teachers = await _fetchTeachers();
    setState(() {
      _teachers = teachers;
      _isLoading = false;
    });
  }

  Future<List<DropdownOption>> _fetchTeachers() async {
    final teacherProvider =
        Provider.of<TeacherProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String uid = authProvider.uid;
    await teacherProvider.fetchUsers(context, uid);
    List<UserModel> teachers = teacherProvider.userList;
    List<DropdownOption> teacherNames = teachers.map((teacher) {
      return DropdownOption(
        value: teacher.uid!,
        label: "${teacher.name} ${teacher.surname}",
      );
    }).toList();

    return teacherNames;
  }

  _onFileChange(File schedule) {
    setState(() {
      _schedule = schedule;
    });
  }

  _onTeachersDropdownChange(DropdownOption option) {
    setState(() {
      _teacherSelected = option;
    });
  }

  Future<void> _uploadSchedule() async {
    if (_schedule != null && _teacherSelected != null) {
      final teacherProvider =
          Provider.of<TeacherProvider>(context, listen: false);
      await teacherProvider.uploadPDFFile(
          context, _schedule!, _teacherSelected!.value);
    } else {
      showSnackBar(context, "Selecciona un archivo y un profesor 🙄",
          SnackBarType.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: RecdatStyles.whiteColor,
        appBar: AppBar(
          title: const Text("Asignacion de horarios"),
          backgroundColor: RecdatStyles.blueDarkColor,
          foregroundColor: RecdatStyles.whiteColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: RecdatFilePicker(
                      fileType: FileType.custom,
                      allowedExtensions: const ['pdf'],
                      onChanged: (File? file) {
                        if (file != null) {
                          _onFileChange(file);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : RecdatDropdown(
                          placeholder: "Seleccionar profesor",
                          controller: widget.teacherSelectionController,
                          options: _teachers ?? [],
                          color: RecdatStyles.textFieldLight,
                          onChange: (DropdownOption option) {
                            _onTeachersDropdownChange(option);
                          },
                        ),
                  const SizedBox(
                    height: 100,
                  ),
                  RecdatButtonAsync(
                    onPressed: () async {
                      await _uploadSchedule();
                    },
                    text: "Asignar horario",
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
