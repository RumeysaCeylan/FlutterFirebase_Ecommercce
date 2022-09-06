import 'dart:io';

import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/Services/StorageService.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageService _storageService = StorageService();
  String mediaUrl = "";

  /*Future<Profile> addProfile(PickedFile pickedFile) async {
    var ref = _firestore.collection("User");

    if (pickedFile == null) {
      mediaUrl = "";
    } else {
      mediaUrl = await _storageService.uploadMedia(File(pickedFile.path));
    }
    var documentRef = await ref.add({'image': mediaUrl});
    return Profile(id: documentRef.id, image: mediaUrl);
  }

  Stream<QuerySnapshot> getUser() {
    var ref = _firestore.collection("User").snapshots();
    return ref;
  }*/
}
