import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final imagePickerProvider = Provider<FilePicker>((ref) => ImagePickerService());

abstract class FilePicker {
  Future<File> getImage();
}

class ImagePickerService implements FilePicker {
  final picker = ImagePicker();
  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }
}
