import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';
import 'package:recdat/shared/widgets/recdat_button_async.dart';
import 'package:recdat/views/pdf_viewer.view.dart';

class RecdatFilePicker extends StatefulWidget {
  final FileType fileType;
  final List<String>? allowedExtensions;
  final Function(File?) onChanged;

  const RecdatFilePicker({
    Key? key,
    required this.fileType,
    this.allowedExtensions,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RecdatFilePickerState createState() => _RecdatFilePickerState();
}

class _RecdatFilePickerState extends State<RecdatFilePicker> {
  File? _selectedFile;
  String? _fileName;

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: widget.fileType,
      allowedExtensions: widget.allowedExtensions,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
      widget.onChanged(_selectedFile);
    }
  }

  void _openPdf(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerView(file: _selectedFile!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        if (_selectedFile != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombre del archivo: $_fileName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildPreview(),
            ],
          ),
        if (_selectedFile == null)
          const Center(
            child: Icon(
              Icons.date_range,
              color: RecdatStyles.defaultTextColor,
              size: 200,
            ),
          ),
        const SizedBox(height: 20),
        if (_fileName != null)
          const Text(
              "Para visualizar el contenido presiona sobre el icono PDF"),
        const SizedBox(
          height: 10,
        ),
        RecdatButtonAsync(
          onPressed: () async {
            await _openFilePicker();
          },
          text: "Seleccionar archivo",
          color: "success",
        ),
      ],
    );
  }

  String getFileExtension(String fileName) {
    int dotIndex = fileName.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < fileName.length - 1) {
      return fileName.substring(dotIndex + 1).toLowerCase();
    }
    return '';
  }

  Widget _buildPreview() {
    final extension = getFileExtension(_fileName!);
    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Image.file(_selectedFile!);
    } else if (extension == 'pdf') {
      return GestureDetector(
        onTap: () => _openPdf(context),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            color: RecdatStyles.whiteColor,
            child:
                const Icon(Icons.picture_as_pdf, size: 80, color: Colors.red),
          ),
        ),
      );
    } else {
      return Text('Vista previa no disponible para este tipo de archivo');
    }
  }
}
