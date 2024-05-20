import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class SnackBarType {
  final String value;

  const SnackBarType._(this.value);

  static const SnackBarType error = SnackBarType._('error');
  static const SnackBarType success = SnackBarType._('success');
  static const SnackBarType warning = SnackBarType._('warning');
  static const SnackBarType none = SnackBarType._('default');
}

void showSnackBar(BuildContext context, String text, SnackBarType type) {
  Color backgroundColor;

  switch (type) {
    case SnackBarType.warning:
      backgroundColor = RecdatStyles.snackbarWarningColor;
      break;
    case SnackBarType.error:
      backgroundColor = RecdatStyles.snackbarErrorColor;
      break;
    case SnackBarType.success:
      backgroundColor = RecdatStyles.snackbarSuccesColor;
      break;
    default:
      backgroundColor = Colors.blueGrey;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: RecdatStyles.whiteColor),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

class GeneralOptionsSelectWidget {
  final String label;
  final String value;

  GeneralOptionsSelectWidget({required this.label, required this.value});
}

class RecdatCollections {
  RecdatCollections._();

  static String institutes() {
    return "institutes";
  }

  static String courses() {
    return "courses";
  }
}

class RecdatDateUtils {
  RecdatDateUtils._();

  static String currentDate() {
    DateTime now = DateTime.now().toUtc().add(Duration(hours: -5));
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);
  }
}

class CourseOptionsUtils {
  CourseOptionsUtils._();

  static List<String> areas() {
    return [
      'INFORMATICA',
      'FISICA',
      'BIOLOGIA',
      'MATEMATICAS',
      'QUIMICA',
      'FILOSOFIA',
      'ETICA Y VALORES',
      'GEOGRAFIA',
      'ECONOMIA',
      'ARTISTICA',
      'HISTORIA',
      'LITERATURA'
    ];
  }

  static List<String> grades() {
    return [
      'VI (6º grado)',
      'VII (7º grado)',
      'VIII (8º grado)',
      'IX (9º grado)',
      'X (10º grado)',
      'XI (11º grado)',
    ];
  }
}
