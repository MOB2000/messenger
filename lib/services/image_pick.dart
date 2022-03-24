import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePick {
  ImagePick._();

  static ImagePick instance = ImagePick._();

  Future<File?> pickImageGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      return imageFile;
    }

    return null;
  }
}
