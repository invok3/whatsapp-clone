import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

abstract class FirebaseAPI {
  static Future<String?> uploadPhoto(
      {required String fileName, required Uint8List fileData}) async {
    try {
      Reference file =
          FirebaseStorage.instance.ref().child("profileImages").child(fileName);
      UploadTask task = file.putData(fileData,
          SettableMetadata(contentType: "image/${fileName.split('.').last}"));
      TaskSnapshot result = await Future.value(task);
      return await result.ref.getDownloadURL();
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
