import 'dart:io';

import 'package:file_selector/file_selector.dart';

class FileSelect {
  //Select an image for encoding or decoding
  static Future<String?> selectImage() async {
    final typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'jpeg', 'png', 'bmp', 'gif'],
    );

    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) {
      return null; // User canceled the picker
    }
    return file.path;
  }

  //Select a save location for the encoded image 
  static Future<String?> selectSaveLocation(File file, String imageName) async {
    final typeGroup = XTypeGroup(label: 'images', extensions: ['png']);
    //Remove extension from image name if it exists and add .png extension
    if (imageName.contains('.')) {
      imageName = imageName.split('.').first;
    }
    String fileName = '$imageName.png';
    final FileSaveLocation? result = await getSaveLocation(
      suggestedName: fileName,
    );
    if (result == null) {
      // Operation was canceled by the user.
      return null;
    }
    XFile xfile = XFile(file.path);
    await xfile.saveTo(result.path);
    return result.path;
  }
}
