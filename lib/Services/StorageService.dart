import 'package:http/http.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadMedia(File file) async {
    var uploadImage = _firebaseStorage
        .ref()
        .child(
            "${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}")
        .putFile(file);
    uploadImage.snapshotEvents.listen((event) {});

    var storageRef = await uploadImage;

    return await storageRef.ref.getDownloadURL();
  }
}
