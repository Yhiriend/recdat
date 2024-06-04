import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class PdfViewerView extends StatelessWidget {
  final File? file;
  final Future<File?>? pdfFuture;

  const PdfViewerView({Key? key, this.file, this.pdfFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa del Archivo'),
        backgroundColor: RecdatStyles.blueDarkColor,
        foregroundColor: RecdatStyles.whiteColor,
      ),
      body: file != null
          ? PDFView(
              filePath: file!.path,
            )
          : FutureBuilder<File?>(
              future: pdfFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(
                    child: Text('Error al cargar el Horario'),
                  );
                } else {
                  return PDFView(filePath: snapshot.data!.path);
                }
              },
            ),
    );
  }
}
