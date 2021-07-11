library firebase_storage_util;

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum UploadDataSource {
  /// [String]
  path,

  /// [File]
  file,

  /// [Uint8List]
  bytes,
}

class CustomStorageUtil {
  CustomStorageUtil._();
  static final instance = CustomStorageUtil._();

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> upload({
    required String uploadPath,
    required UploadDataSource uploadDataSource,
    String? path,
    File? file,
    Uint8List? bytes,
    bool getDownloadUrl = false,
  }) async {
    String? downloadUrl;

    switch (uploadDataSource) {
      case UploadDataSource.path:
        assert(path != null);
        await _uploadFromPath(uploadPath: uploadPath, path: path!);
        break;
      case UploadDataSource.file:
        assert(file != null);
        await _uploadFromFile(uploadPath: uploadPath, file: file!);
        break;
      case UploadDataSource.bytes:
        assert(bytes != null);
        _uploadFromBytes(uploadPath: uploadPath, bytes: bytes!);

        break;
    }
    if (getDownloadUrl)
      downloadUrl = await storage.ref(uploadPath).getDownloadURL();

    return downloadUrl;
  }

  Future<void> _uploadFromPath(
      {required String uploadPath, required String path}) async {
    try {
      await storage.ref(uploadPath).putFile(File(path)).whenComplete(() {});
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      throw e.code;
    }
  }

  Future<void> _uploadFromFile(
      {required String uploadPath, required File file}) async {
    try {
      await storage.ref(uploadPath).putFile(file).whenComplete(() {});
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      throw e.code;
    }
  }

  Future<void> _uploadFromBytes(
      {required String uploadPath, required Uint8List bytes}) async {
    try {
      await storage.ref(uploadPath).putData(bytes).whenComplete(() {});
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      throw e.code;
    }
  }
}
