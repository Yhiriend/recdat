import 'package:flutter/material.dart';
import 'package:recdat/modules/attendance/model/attendance.model.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class CardAttendanceWidget extends StatefulWidget {
  final bool isAttendance;
  final Attendance attendance;
  const CardAttendanceWidget(
      {Key? key, required this.isAttendance, required this.attendance})
      : super(key: key);

  @override
  State<CardAttendanceWidget> createState() => _CardAttendanceWidgetState();
}

class _CardAttendanceWidgetState extends State<CardAttendanceWidget> {
  bool _canEdit = true;

  @override
  void initState() {
    super.initState();
    _canEdit = true;
    isChangeEnabled();
  }

  void isChangeEnabled() {
    _canEdit = true;
    Future.delayed(const Duration(minutes: 1), () {
      setState(() {
        _canEdit = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _isAttendance = widget.isAttendance;
    Attendance _attendance = widget.attendance;
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
                          ? RecdatStyles.opaquePrimaryBackgroundColor
                          : RecdatStyles.opaqueGrayBackgroundColor,
                    ),
                    child: Center(
                      child: _isAttendance
                          ? const Icon(
                              Icons.check,
                              size: 58,
                              color: RecdatStyles.opaquePrimaryForegroundColor,
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
                      _attendance.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: RecdatStyles.darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      _attendance.createdAt,
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
            if (_canEdit)
              Positioned(
                top: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: RecdatStyles.iconDefaulColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {},
                      icon: const Icon(Icons.delete,
                          color: RecdatStyles.iconDefaulColor),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
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
