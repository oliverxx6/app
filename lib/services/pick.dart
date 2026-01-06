import 'package:image_picker/image_picker.dart';

class ImagePic {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }
}
