import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class PhotoStorage {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static String _url = "";

  static Future<bool> uploadPhotoInStorage(
    String? userId,
    String? email,
    File file,
  ) async {
    //AQUI EXTRAIGO SOLO EL NOMBRE DEL ARCHIVO
    String fileName = file.path.split("/").last;
    //AQUI CREO LA ESTRUCTURA DEL DOCUMENTO
    final montainRef = _storage
        .ref()
        .child("users")
        .child(userId!)
        .child(email!)
        .child(fileName);
    //AQUI SUBO EL VIDEO DENTRO DE ESTE DOCUMENTO
    final UploadTask saveVideo = montainRef.putFile(file);
    //AQUI VERIFICO SI LA TAREA ARRIBA ASIGNADA SE CUMPLIO O NO
    TaskSnapshot workDone = await saveVideo.whenComplete(() => true);
    //AQUI DESCARGO EL URL NECESARIO PARA PRE CARGAR EL VIDEO
    _url = await workDone.ref.getDownloadURL();

    if (workDone.state == TaskState.success) {
      return true;
    } else {
      return false;
    }
  }

  static String getUrl() {
    String imageUrl = _url;
    return imageUrl;
  }

  static Future<bool> deletePhoto(
    String? userId,
    String? email,
    String nameFile,
  ) async {
    try {
      Reference? deletePhoto = _storage
          .ref()
          .child("users")
          .child(userId!)
          .child(email!)
          .child(nameFile);
      await deletePhoto.delete();
      return true;
    } catch (e) {
      e;
      return false;
    }
  }
}
