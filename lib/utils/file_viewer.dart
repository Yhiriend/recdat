import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:recdat/utils/utils.dart';
import 'package:recdat/views/file_viewer.view.dart';
import 'package:recdat/views/image_viewer.view.dart';

class FileHelper {
  /*static Future<File?> getScheduleFile(BuildContext context, String fileName) async {
    final teacherProvider = Provider.of<UserProvider>(context, listen: false);
    return await teacherProvider.getTeacherFile(context, fileName);
  }*/

  /*static Future<void> openSchedule(BuildContext context, String fileName, String fileType) async {
    final file = await getScheduleFile(context, fileName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileViewerView(file: file, fileType: fileType),
      ),
    );
  }*/
  static Future<dynamic> getFile(BuildContext context, String userUid,
      String fileUid, String operation) async {
    try {
      String path;
      String fileName;

      // Definir la ruta y el nombre del archivo basado en la operación
      switch (operation) {
        case 'schedule':
          path = 'teacher_schedules/$userUid/horario.pdf';
          fileName = 'horario.pdf';
          break;
        case 'attendanceFile':
          String fileUUID = fileUid;
          path = 'attendances/$userUid/$fileUUID';
          fileName = fileUUID;
          break;
        case 'image':
          path = 'images/$userUid/image.jpg';
          fileName = 'image.jpg';
          break;
        default:
          throw Exception('Operación no soportada');
      }

      // Obtener el archivo basado en la operación
      if (operation == 'image' || operation == "attendanceFile") {
        print("PATH: $path");
        String downloadUrl =
            await FirebaseStorage.instance.ref(path).getDownloadURL();
        return downloadUrl;
      } else {
        File file = File('${(await Directory.systemTemp).path}/$fileName');
        await FirebaseStorage.instance.ref(path).writeToFile(file);
        return file;
      }
    } catch (e) {
      showSnackBar(context, "Error al obtener el archivo", SnackBarType.error);
      return null;
    }
  }

  // Método para abrir el archivo obtenido
  static Future<void> openFile(BuildContext context, String userUid,
      String fileUid, String operation) async {
    final file = await getFile(context, userUid, fileUid, operation);
    if (file != null) {
      if (operation == 'image') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewerView(imageUrl: file),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FileViewerView(file: file, fileType: 'pdf'),
          ),
        );
      }
    } else {
      showSnackBar(context, "No se pudo abrir el archivo", SnackBarType.error);
    }
  }
}
