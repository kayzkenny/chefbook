import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

final storageProvider = Provider<Storage>((ref) => FirebaseStorageService());

abstract class Storage {
  Future<String> uploadFile(File file);
  Future<void> deleteFile(String downloadURL);
}

class FirebaseStorageService implements Storage {
  @override
  Future<String> uploadFile(File file) async {
    final String filename = path.basename(file.path);
    final storageReference =
        FirebaseStorage.instance.ref().child('UPLOADS/$filename');
    final UploadTask uploadTask = storageReference.putFile(file);
    final taskSnapshot = await uploadTask;
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Future<void> deleteFile(String downloadURL) async {
    final storageReference = FirebaseStorage.instance.refFromURL(downloadURL);
    await storageReference.delete();
  }
}
