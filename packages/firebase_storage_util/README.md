# firebase_storage_util

Helper for [firebase_storage](https://pub.dev/packages/firebase_storage) common operations.  

NOTE: the firebase app must be setup for this package to work. See [add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup).





## Use this package as a library

### Depend on it
```
dependencies:
  firebase_storage_util:
    git: 
        url: git://github.com/bringbackthedog/custom_flutter_packages.git 
        path: packages/firebase_storage_util
```

### Import it

```
import 'package:firebase_storage_util/firebase_storage_util.dart';
```


### Example usage

```dart
/// Upload the file to storage's [uploadPath] and return the [downloadUrl] if upload was successful.
String? downloadUrl = await FirebaseStorageUtil.instance
  .upload(
    uploadPath: 'example/path',
    uploadDataSource: UploadDataSource.file,
    file: File('path/to/file/on/device'),
    getDownloadUrl: true,
);
```


<!-- My personal Flutter packages.  -->
