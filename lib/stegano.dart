import 'dart:io';

import 'package:steganograph/steganograph.dart';

class Stegano {
  static Future<File?> encode(String message, String imagePath) async {
    return await Steganograph.cloak(
      image: File(imagePath),
      message: message,
      outputFilePath: 'result.png'
    );
  }
  // @TODO recompress the image to reduce file size, currently the output is a png
  static Future<String?> decode(String imagePath) async {
    return await Steganograph.uncloak(File(imagePath));
  }
}
