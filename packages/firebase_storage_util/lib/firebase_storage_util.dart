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

  /// Upload a file to project's Firebase storage.
  ///
  /// The appropriate source argument must be provided (i.e.: if
  /// [UploadDataSource] == [UploadDataSource.bytes],  [bytes] must be provided
  /// )
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

  /// Delete a file from storage from its storage path.
  Future<void> deleteFromPath({required String path}) async {
    Reference ref = storage.ref(path);
    try {
      await ref.delete();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  /// Delete a file from storage from its storage reference [url] (i.e. the url
  /// returned from `ref.getDownloadURL()`).
  Future<void> deleteFromUrl({required String url}) async {
    Reference ref = storage.refFromURL(url);
    try {
      await ref.delete();
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }

  /// Delete file reference from its storage url or from storage path.
  ///
  /// Either [url] or [path] must be provided.
  Future<void> delete({String? url, String? path}) async {
    assert((url != null) ^ (path != null), "Must provide either url or path");

    try {
      url != null ? deleteFromUrl(url: url) : deleteFromPath(path: path!);
    } on FirebaseException catch (e) {
      throw e.code;
    }
  }
}
