import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoStorage {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static String _url = "";

  static Future<bool> uploadPhotoInStorage(
    String? userId,
    String fileName,
    Uint8List bytes,
  ) async {
    // Detectar el tipo según la extensión
    final ext = fileName.split('.').last.toLowerCase();
    String contentType;

    switch (ext) {
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';
        break;
      case 'png':
        contentType = 'image/png';
        break;
      case 'gif':
        contentType = 'image/gif';
        break;
      case 'webp':
        contentType = 'image/webp';
        break;
      case 'heic':
        contentType = 'image/heic';
        break;
      default:
        contentType = 'application/octet-stream';
    }

    //AQUI CREO LA ESTRUCTURA DEL DOCUMENTO
    final montainRef = _storage
        .ref()
        .child("users")
        .child(userId!)
        .child("photo")
        .child(fileName);
    //AQUI SUBO la foto DENTRO DE ESTE DOCUMENTO
    final UploadTask savePhoto = montainRef.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );

    //AQUI VERIFICO SI LA TAREA ARRIBA ASIGNADA SE CUMPLIO O NO
    TaskSnapshot workDone = await savePhoto.whenComplete(() => true);
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

  static Future<bool> deletePhoto(String? userId, String nameFile) async {
    try {
      Reference? deletePhoto = _storage
          .ref()
          .child("users")
          .child(userId!)
          .child("photo")
          .child(nameFile);
      await deletePhoto.delete();
      return true;
    } catch (e) {
      e;
      return false;
    }
  }
}
