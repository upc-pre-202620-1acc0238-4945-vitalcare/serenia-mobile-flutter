import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class MessagePhotoPicker {
  static Future<Uint8List?> pickFromGallery() async {
    try {
      final XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return await file?.readAsBytes();
    } catch (_) {
      return null;
    }
  }
}
