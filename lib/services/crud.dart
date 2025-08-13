import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Crud {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;
  static List<dynamic> iddoc = [];
  static Future<bool> createCollection(
    String? userId,
    String? email,
    String? name,
    String? lastName,
    String age,
    String id,
    String phone,
  ) async {
    try {
      final userDoc = await _connec.collection("users").doc(userId).get();
      if (!userDoc.exists) {
        await _connec
            .collection("users")
            .doc(userId)
            .set({}); //creo el documento vacio
      }
      final Map<String, dynamic> data = {
        "Nombre": name,
        "Apellido": lastName,
        "Edad": age,
        "Cedula": id,
        "Celular": phone,
      };
      await _connec
          .collection("users")
          .doc(userId)
          .collection(email!)
          .add(data);
      return true;
    } catch (e) {
      e;
      return false;
    }
  }

  static Future<List<dynamic>> readInfo(String? userId, String? email) async {
    List personalInfo = [];

    await _connec.collection("users").doc(userId).collection(email!).get().then(
      (value) {
        for (var i in value.docs) {
          final Map<String, dynamic> info;
          info = {"idDoc": i.id, "infoPersonal": i.data()};
          personalInfo.add(info);
        }
      },
    );
    iddoc = personalInfo;
    return personalInfo;
  }

  static Future<bool> deleteInfo(
    String? userId,
    String? email,
    String? idDoc,
  ) async {
    try {
      await _connec
          .collection("users")
          .doc(userId)
          .collection(email!)
          .doc(idDoc)
          .delete();
      return true;
    } catch (e) {
      e;
      return false;
    }
  }
}

class CrudAdvertisement {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;
  static final _controller = StreamController<List>();
  static Stream<List>? get advertisementStream => _controller.stream;

  static Future<void> dispose() async {
    await _controller.close();
  }

  static Future<bool> createAdvertisement(
    String? userId,
    String? email,
    String? profetion,
    String? description,
    String? value,
    String? location,
  ) async {
    try {
      final userDoc = await _connec.collection("users").doc(userId).get();
      if (!userDoc.exists) {
        await _connec
            .collection("users")
            .doc(userId)
            .set({}); //creo el documento vacio
      }
      final Map<String, dynamic> data = {
        "profetion": profetion,
        "description": description,
        "value": value,
        "location": location,
      };
      await _connec
          .collection("users")
          .doc(userId)
          .collection(email!)
          .doc("anuncio")
          .collection("anuncios")
          .add(data);
      return true;
    } catch (e) {
      e;
      return false;
    }
  }

  static Future<void> readAdvertisement(String? userId, String? email) async {
    List advertisement = [];

    await _connec
        .collection("users")
        .doc(userId)
        .collection(email!)
        .doc("anuncio")
        .collection("anuncios")
        .get()
        .then((value) {
          for (var i in value.docs) {
            final Map<String, dynamic> info;
            info = {"idDoc": i.id, "advertisement": i.data()};
            advertisement.add(info);
          }
        });
    _controller.add(advertisement);
  }

  static Future<bool> deleteAdvertisement(
    String? userId,
    String? email,
    String? idDoc,
  ) async {
    try {
      await _connec
          .collection("users")
          .doc(userId)
          .collection(email!)
          .doc("anuncio")
          .collection("anuncios")
          .doc(idDoc)
          .delete();
      return true;
    } catch (e) {
      e;
      return false;
    }
  }
}

class CreateDBPhoto {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final _controller = StreamController<List>();
  static Stream<List>? get photoStream => _controller.stream;

  static Future<void> disposePhotoStream() async {
    await _controller.close();
  }

  static Future<bool> createCollectionPhoto(
    String? userId,
    String? email,
    String url,
    String file,
  ) async {
    try {
      final userDoc = await _db.collection("users").doc(userId).get();
      if (!userDoc.exists) {
        await _db.collection("users").doc(userId).set({});
      }
      final Map<String, dynamic> data = {
        "urlPhoto": url, // Dato de foto
        "filePhoto": file, // Dato del archivo
      };

      await _db
          .collection("users")
          .doc(userId)
          .collection(email!)
          .doc("foto")
          .collection("trabajos")
          .add(data);
      return true;
    } catch (e) {
      e;
      return false;
    }
  }

  static Future<void> readPhoto(String? userId, String? email) async {
    List photo = [];

    await _db
        .collection("users")
        .doc(userId)
        .collection(email!)
        .doc("foto")
        .collection("trabajos")
        .get()
        .then((value) {
          for (var i in value.docs) {
            final Map<String, dynamic> info;
            info = {"idDoc": i.id, "data": i.data()};
            photo.add(info);
          }
        });
    _controller.add(photo);
  }

  static Future<bool> deleteDataPhoto(
    String? userId,
    String? email,
    String idDocs,
  ) async {
    try {
      await _db
          .collection("users")
          .doc(userId)
          .collection(email!)
          .doc("foto")
          .collection("trabajos")
          .doc(idDocs)
          .delete();
      return true;
    } catch (e) {
      e;
      return false;
    }
  }
}

class CrudProfessional {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;
  static final _controller = StreamController<List>();
  static Stream<List>? get professionalStream => _controller.stream;

  static Future<void> dispose() async {
    await _controller.close();
  }

  static Future<bool> createProfessionalPerfil(
    String? userId,
    String? email,
    String? profetion,
    String? expert,
    String? expertDescription,
    String? phone,
  ) async {
    try {
      final userDoc = await _connec.collection("users").doc(userId).get();
      if (!userDoc.exists) {
        await _connec
            .collection("users")
            .doc(userId)
            .set({}); //creo el documento vacio
      }
      final Map<String, dynamic> data = {
        "Profesion": profetion,
        "Experiencia": expert,
        "Descripcion": expertDescription,
        "Celular": phone,
      };
      await _connec
          .collection("users")
          .doc(userId)
          .collection(email!)
          .doc("profesiones")
          .collection("profesion")
          .add(data);
      return true;
    } catch (e) {
      e;
      return false;
    }
  }

  static Future<void> readProfetion(String? userId, String? email) async {
    List profetions = [];

    await _connec
        .collection("users")
        .doc(userId)
        .collection(email!)
        .doc("profesiones")
        .collection("profesion")
        .get()
        .then((value) {
          for (var i in value.docs) {
            final Map<String, dynamic> info;
            info = {"idDoc": i.id, "profession": i.data()};
            profetions.add(info);
          }
        });
    _controller.add(profetions);
  }

  static Future<bool> deleteProfetion(
    String? userId,
    String? email,
    String? idDoc,
  ) async {
    try {
      await _connec
          .collection("users")
          .doc(userId)
          .collection(email!)
          .doc("profesiones")
          .collection("profesion")
          .doc(idDoc)
          .delete();
      return true;
    } catch (e) {
      e;
      return false;
    }
  }
}
