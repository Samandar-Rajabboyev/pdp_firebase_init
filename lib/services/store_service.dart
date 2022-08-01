import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "post_images";

  static Future<String> uploadImage(File _image) async {
    String? downloadUrl;
    String imgName = "image_${DateTime.now()}";
    Reference firebaseStorageRef = _storage.child(folder).child(imgName);
    await firebaseStorageRef.putFile(_image).then((p0) async {
      if (p0.state == TaskState.success) {
        await firebaseStorageRef.getDownloadURL().then((url) {
          print(url);
          downloadUrl = url;
        });
      }
    });
    if (kDebugMode) {
      print(downloadUrl);
    }
    return downloadUrl ?? 'https://returntofreedom.org/store/wp-content/uploads/default-placeholder.png';
  }
}
