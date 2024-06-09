import 'package:flutter/material.dart';
import 'package:recdat/modules/user/model/user.model.dart';
import 'package:recdat/modules/user/views/edit_teacher.view.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class CardAttendanceWidget extends StatelessWidget {
  final UserModel teacher;

  const CardAttendanceWidget({
    required this.teacher,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: RecdatStyles.opaquePrimaryBackgroundColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        size: 58,
                        color: RecdatStyles.opaquePrimaryForegroundColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inasistencia",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: RecdatStyles.darkTextColor,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Esta es la descripcion para una inasistencia, por ejemplo puede ser que haya sido por cuestiones de cita medica o algo parecido.",
                      style: TextStyle(
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
            Positioned(
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditTeacherWiew(teacher: teacher)));
                    },
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

  String _getTotalCourses(List<dynamic>? courses) {
    if (courses != null) {
      int total = courses.length;
      if (total == 0) {
        return "sin cursos";
      } else if (total == 1) {
        return "+1 curso";
      } else {
        return "+$total cursos";
      }
    }
    return "sin cursos";
  }

  String _truncateText(String text, int maxWords) {
    List<String> words = text.split(' ');
    if (words.length <= maxWords) {
      return text;
    }
    return '${words.sublist(0, maxWords).join(' ')}...';
  }

  String _splitText(String grade) {
    return grade.split(" ")[0].trim().toString();
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
