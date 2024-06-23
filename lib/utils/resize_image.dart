import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<XFile?> compressAndGetFile(File file) async {
  dynamic result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    "assets/profile/pic_thumbnail.jpg",
    quality: 88,
    rotate: 180,
  );
  return result;
}
