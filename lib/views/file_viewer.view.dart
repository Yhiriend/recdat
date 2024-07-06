import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class FileViewerView extends StatelessWidget {
  final File? file;
  final Future<File?>? fileFuture;
  final String? fileType;

  const FileViewerView({Key? key, this.file, this.fileFuture, this.fileType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa del Archivo'),
        backgroundColor: RecdatStyles.blueDarkColor,
        foregroundColor: RecdatStyles.whiteColor,
      ),
      body: file != null
          ? _buildFileView(file!, fileType)
          : FutureBuilder<File?>(
              future: fileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                    child: Text('Error al cargar el Archivo'),
                  );
                } else {
                  return _buildFileView(snapshot.data!, fileType);
                }
              },
            ),
    );
  }

  Widget _buildFileView(File file, String? fileType) {
    switch (fileType) {
      case 'pdf':
        return PDFView(filePath: file.path);
      case 'image':
        return Image.file(file);
      default:
        return Center(child: Text('Tipo de archivo no soportado'));
    }
  }
}
