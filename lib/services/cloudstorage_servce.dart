import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

const String UserCollection = "Users";

class CloudstorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  CloudstorageService();
  Future<String?> saveuserImageToStorage(
      String uid, PlatformFile file) async {
    try {
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');

      UploadTask task = ref.putFile(File(file.path!));
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> saveChatImageToStorage(
      String ChatId, String userId, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/chats/$ChatId/${userId}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(File(file.path!));
      return await task.then((result) => result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
    return null;
  }
}
