import 'package:flutter/material.dart';
import 'package:recdat/modules/course/model/course.model.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class CardCourseWidget extends StatelessWidget {
  final String title;
  final String description;
  final String courseType;
  final String grade;

  const CardCourseWidget({
    required this.title,
    required this.description,
    required this.courseType,
    required this.grade,
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
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: RecdatStyles.opaquePrimaryBackgroundColor,
                  ),
                  child: Center(
                    child: Text(
                      _splitText(grade),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: RecdatStyles
                            .opaquePrimaryForegroundColor, // Puedes cambiar el color del texto aquí
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
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
                      _truncateText(title, 3),
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal,
                        color: RecdatStyles.darkTextColor,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      _truncateText(description, 3),
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: RecdatStyles.defaultTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 10.0),
                    _buildCourseTypeBadge(courseType),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.edit,
                  color: RecdatStyles.iconDefaulColor,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete,
                    color: RecdatStyles.iconDefaulColor),
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

  String _splitText(String grade) {
    return grade.split(" ")[0].trim().toString();
  }

  Widget _buildCourseTypeBadge(String courseType) {
    Color badgeColor;

    switch (courseType) {
      case CourseType.math:
        badgeColor = Colors.blue;
        break;
      case CourseType.biology:
        badgeColor = Colors.green;
        break;
      case CourseType.informatic:
        badgeColor = Colors.orange;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        courseType,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
