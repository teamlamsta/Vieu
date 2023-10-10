import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileServices{
  static Future<String> storeFile(File image)async{
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final savedImageFile = await image.copy('${appDir.path}/$uniqueFileName.png');

      // Now you have the path to the saved image
      final imagePath = savedImageFile.path;

      return imagePath;
    } catch (e) {
      // Handle any errors that occur during file saving
      print("Error saving image: $e");
    }
    return "";

  }


}