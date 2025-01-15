import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fullstack_social_media_app/features/storage/domain/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  /*
    Firebase Storage profiles
  */
  final FirebaseStorage storage = FirebaseStorage.instance;

  // mobile platform
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  /*
    Firebase Storage posts
  */

  // mobile platform
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  /*
    Helper methods - to upload files to storage  
  */

  // mobile platforms when uploading files
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      // Get the file
      final file = File(path);

      // Define the storage reference
      final storageRef = storage.ref().child('$folder/$fileName');

      // Define metadata with the MIME type
      // final metadata = SettableMetadata(contentType: 'image/jpeg');

      // Upload the file with metadata
      final uploadTask = await storageRef.putFile(file);

      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading file (mobile): $e');
      return null;
    }
  }

  // web platforms when uploading bytes
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      // Define the storage reference
      final storageRef = storage.ref().child('$folder/$fileName');

      // Define metadata with the MIME type
      // final metadata = SettableMetadata(contentType: 'image/jpeg');

      // Upload the file with metadata
      final uploadTask = await storageRef.putData(fileBytes);

      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading file (web): $e');
      return null;
    }
  }
}
