import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<Widget> buildAutoRotatedImage(String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);

  // Deteksi orientasi: jika tinggi > lebar → portrait
  final bool isPortrait = image!.height > image.width;

  return AspectRatio(
    aspectRatio: isPortrait ? 4 / 3 : image.width / image.height,
    child: Transform.rotate(
      angle: isPortrait ? 360 * 3.14 / 180 : 0, // Rotate hanya jika portrait
      child: Image.file(
        file,
        fit: BoxFit.cover,
      ),
    ),
  );
}
