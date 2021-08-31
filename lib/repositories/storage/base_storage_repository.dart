import 'dart:io';

abstract class BaseStorageRepositoy {
  Future<String> upLoadProfileImage({String url, File image});
  Future<String> uploadPostImage({File image});
}
