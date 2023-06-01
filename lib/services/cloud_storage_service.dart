import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:city_of_carnation/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

class CloudStorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> updateUserProfilePhoto(
      {required File imageFile}) async {
    final ref = _storage.ref().child('user-storage').child(AuthService.userId!);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  static Future<String> uploadWorkOrderPhoto(
      {required File imageFile, required String name}) async {
    final ref = _storage.ref('user-storage').child(
        '${AuthService.userId}/work-orders/images/${DateTime.now().millisecondsSinceEpoch}-${_randomAlphaNumeric(5)}-${sanitizeFilename(name)}');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  static String _randomAlphaNumeric(int i) {
    var random = Random.secure();
    var values = List<int>.generate(i, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }
}
