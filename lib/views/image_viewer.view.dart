import 'package:flutter/material.dart';
import 'package:recdat/shared/global-styles/recdat.styles.dart';

class ImageViewerView extends StatelessWidget {
  final String imageUrl;

  const ImageViewerView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista previa de la Imagen'),
        backgroundColor: RecdatStyles.blueDarkColor,
        foregroundColor: RecdatStyles.whiteColor,
      ),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Image.network(imageUrl)
            : const Text('Error al cargar la imagen'),
      ),
    );
  }
}
