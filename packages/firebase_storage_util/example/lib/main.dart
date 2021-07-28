import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage_util/firebase_storage_util.dart';

void main() {
  runApp(FirebaseStorageUtilExample());
}

class FirebaseStorageUtilExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            String? url = await FirebaseStorageUtil.instance.upload(
              uploadPath: 'example/path',
              uploadDataSource: UploadDataSource.file,
              file: File('path/to/file/on/device'),
              getDownloadUrl: true,
            );
          },
          child: Text('Upload'),
        ),
      ),
    );
  }
}
