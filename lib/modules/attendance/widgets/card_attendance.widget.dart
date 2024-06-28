import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/modules/user/providers/teacher.provider.dart';
import 'package:recdat/providers/auth.providers.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class CardAttendanceWidget extends StatefulWidget {
  final bool isAttendance;
  final Attendance attendance;
  final String userUUID;
  final ValueNotifier<bool> isDeletedNotifier;
  const CardAttendanceWidget(
      {Key? key,
      required this.isDeletedNotifier,
      required this.isAttendance,
      required this.attendance,
      required this.userUUID})
      : super(key: key);

  @override
  State<CardAttendanceWidget> createState() => _CardAttendanceWidgetState();
}

class _CardAttendanceWidgetState extends State<CardAttendanceWidget> {
  bool? _canEdit;
  int? _counter;
  Timer? _timer;
  String _userUUID = "";
  Attendance? _attendance;

  @override
  void initState() {
    super.initState();
    _canEdit = widget.attendance.canEdit;
    _userUUID = widget.userUUID;
    _attendance = widget.attendance;
    _counter = _canEdit! ? 60 : 0;
    isChangeEnabled();
  }

  void isChangeEnabled() {
    if (_canEdit!) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _counter = (_counter ?? 0) - 1;
          if (_counter! <= 0) {
            _canEdit = false;
            _timer?.cancel();
          }
        });
      });

      Future.delayed(const Duration(minutes: 1), () {
        if (mounted) {
          setState(() {
            _canEdit = false;
            final teacherProvider =
                Provider.of<UserProvider>(context, listen: false);

            teacherProvider.updateAttendanceCanEdit(
                context, _userUUID, _attendance!.uuid);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _isAttendance = widget.isAttendance;
    return ValueListenableBuilder(
      valueListenable: widget.isDeletedNotifier,
      builder: (context, isDeleted, child) {
        if (isDeleted) {
          return SizedBox(); // Widget vacío si se ha eliminado
        }

        return Card(
          color: RecdatStyles.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isAttendance
                              ? RecdatStyles.opaqueGreenBackgroundColor
                              : RecdatStyles.opaqueGrayBackgroundColor,
                        ),
                        child: Center(
                          child: _isAttendance
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: RecdatStyles
                                              .opaqueGreenForegroundColor, // Color del borde
                                          width: 4, // Grosor del borde
                                        ),
                                        color: Colors
                                            .transparent, // Fondo transparente
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check,
                                          size: 40,
                                          color: RecdatStyles
                                              .opaqueGreenForegroundColor, // Color del icono
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.error_outline,
                                  size: 58,
                                  color: RecdatStyles.opaqueGrayForegroundColor,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _attendance!.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            color: RecdatStyles.darkTextColor,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          _attendance!.createdAt,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: RecdatStyles.parraphLightColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
                if (_canEdit!)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(children: [
                          IconButton(
                            onPressed: () async {
                              final teacherProvider = Provider.of<UserProvider>(
                                  context,
                                  listen: false);
                              await teacherProvider
                                  .deleteAttendance(
                                      context: context,
                                      userUid: _userUUID,
                                      attendanceUid: _attendance!.uuid)
                                  .then((_) {
                                final authProvider = Provider.of<AuthProvider>(
                                    context,
                                    listen: false);
                                authProvider.syncUserDataByUid(
                                    context, _userUUID);
                              });
                            },
                            icon: const Icon(Icons.delete,
                                color: RecdatStyles.iconDefaulColor),
                          ),
                          Positioned(
                            bottom: -4,
                            right: 18,
                            child: Text(
                              _counter.toString().padLeft(2, '0'),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    return '${words.sublist(0, maxWords).join(' ')}...';
  }

  Widget _buildCourseTypeBadge(String email, bool isActive) {
    Color badgeColor;

    if (isActive) {
      badgeColor = Colors.teal;
    } else {
      badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        email,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
