import 'dart:io';

import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/Services/StorageService.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StorageService _storageService = StorageService();
  String mediaUrl = "";

  /*Future<Task> addTask(String task) async {
    var ref = _firestore.collection("Task");

    var documentRef = await ref.add({'task': task});
    return Task(id: documentRef.id, task: task);
  }

  //show data
  Stream<QuerySnapshot> getTask() {
    var ref = _firestore.collection("Task").snapshots();
    return ref;
  }

  Future<void> removeTask(String docId) {
    var ref = _firestore.collection("Task").doc(docId).delete();
    return ref;
  }*/
}
