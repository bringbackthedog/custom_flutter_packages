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

class FirebaseStorageUtil {
  FirebaseStorageUtil._();
  static final instance = FirebaseStorageUtil._();

  FirebaseStorage storage = FirebaseStorage.instance;

  /// Upload a file to project's Firebase storage.
  ///
  /// [uploadPath] is the path where the file should be upload in firebase
  /// storage.
  ///
  /// The appropriate source argument must be provided.
  ///
  /// i.e.:
  ///
  ///   if [UploadDataSource] == [UploadDataSource.bytes],  [bytes] must be
  ///    provided
  ///
  ///   if [UploadDataSource] == [UploadDataSource.file],  [file] must be
  ///    provided
  ///
  ///   if [UploadDataSource] == [UploadDataSource.path],  [path] must be
  ///    provided
  ///
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
        await uploadFromPath(uploadPath: uploadPath, path: path!);
        break;
      case UploadDataSource.file:
        assert(file != null);
        await uploadFromFile(uploadPath: uploadPath, file: file!);
        break;
      case UploadDataSource.bytes:
        assert(bytes != null);
        uploadFromBytes(uploadPath: uploadPath, bytes: bytes!);

        break;
    }
    if (getDownloadUrl)
      downloadUrl = await storage.ref(uploadPath).getDownloadURL();

    return downloadUrl;
  }

  Future<String?> uploadFromPath({
    required String uploadPath,
    required String path,
    bool getDownloadUrl = false,
  }) async {
    String? downloadUrl;
    try {
      await storage.ref(uploadPath).putFile(File(path)).whenComplete(() {});

      if (getDownloadUrl)
        downloadUrl = await storage.ref(uploadPath).getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      throw e.code;
    }
  }

  Future<String?> uploadFromFile({
    required String uploadPath,
    required File file,
    bool getDownloadUrl = false,
  }) async {
    String? downloadUrl;
    try {
      await storage.ref(uploadPath).putFile(file).whenComplete(() {});

      if (getDownloadUrl)
        downloadUrl = await storage.ref(uploadPath).getDownloadURL();

      return downloadUrl;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      throw e.code;
    }
  }

  Future<String?> uploadFromBytes({
    required String uploadPath,
    required Uint8List bytes,
    bool getDownloadUrl = false,
  }) async {
    String? downloadUrl;

    try {
      await storage.ref(uploadPath).putData(bytes).whenComplete(() {});

      if (getDownloadUrl)
        downloadUrl = await storage.ref(uploadPath).getDownloadURL();

      return downloadUrl;
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
