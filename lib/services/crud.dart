import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
    String recomendation,
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
        "estado": "pendiente",
        "Recomendado": recomendation,
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

  static Future<void> readInfo(String userId, String email) async {
    await _connec.collection("users").doc(userId).collection(email).get().then((
      value,
    ) {
      for (var i in value.docs) {
        final Map<String, dynamic> dataContents;
        dataContents = {"idDoc": i.id, "data": i.data()};
        iddoc.add(dataContents);
      }
    });
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
  static Stream<List<Map<String, dynamic>>> getAdvertisementStream(
    String? userId,
    String? email,
  ) {
    return _connec
        .collection("users")
        .doc(userId)
        .collection(email!)
        .doc("anuncio")
        .collection("anuncios")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {"idDoc": doc.id, "advertisement": doc.data()};
          }).toList();
        });
  }

  static Future<bool> createAdvertisement(
    String? userId,
    String? email,
    String? profetion,
    String? description,
    String? value,
    String? location,
    String doc,
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
        "idDocJob": doc,
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

class CrudJob {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;
  static Stream<List<Map<String, dynamic>>> jobStream(
    String? job,
    String? city,
  ) {
    return _connec
        .collection("Jobs")
        .doc(job)
        .collection(city!)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {"idDoc": doc.id, "profession": doc.data()};
          }).toList();
        });
  }

  static Future<bool> createJob(
    String? userId,
    String? email,
    String? job,
    String? description,
    String? value,
    String? location,
    String? phone,
  ) async {
    try {
      final jobDoc = await _connec.collection("Jobs").doc(job).get();
      if (!jobDoc.exists) {
        await _connec
            .collection("Jobs")
            .doc(job)
            .set({}); //creo el documento vacio
      }
      final Map<String, dynamic> data = {
        "userIdUsuario": userId,
        "emailUsuario": email,
        "profetion": job,
        "description": description,
        "value": value,
        "location": location,
        "phone": phone,
      };
      final docRef = await _connec
          .collection("Jobs")
          .doc(job)
          .collection(location!)
          .add(data);
      final String doc = docRef.id;
      await CrudAdvertisement.createAdvertisement(
        userId,
        email,
        job,
        description,
        value,
        location,
        doc,
      );
      return true;
    } catch (e) {
      e;
      return false;
    }
  }

  static Future<bool> deleteProfetion(
    String? job,
    String? idDoc,
    String? city,
  ) async {
    try {
      await _connec
          .collection("Jobs")
          .doc(job)
          .collection(city!)
          .doc(idDoc)
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
  static Stream<List<Map<String, dynamic>>> getProfessionalStream(
    String? userId,
    String? email,
  ) {
    return _connec
        .collection("users")
        .doc(userId)
        .collection(email!)
        .doc("profesiones")
        .collection("profesion")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return {"idDoc": doc.id, "profession": doc.data()};
          }).toList();
        });
  }

  static Future<bool> createProfessionalPerfil(
    String? userId,
    String? email,
    String? profetion,
    String? profession,
    String? city,
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
        "ProfesionTwo": profession,
        "Ciudad": city,
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
          .doc("perfil")
          .set(data, SetOptions(merge: true));
      return true;
    } catch (e) {
      e;
      return false;
    }
  }

  static Future<void> saveFcmToken(
    String? userId,
    String? token,
    String? profession,
    String? professionTwo,
  ) async {
    final List<String> professions = [];
    if (profession != null && profession.isNotEmpty) {
      professions.add(profession);
    }
    if (professionTwo != null && professionTwo.isNotEmpty) {
      professions.add(professionTwo);
    }
    if (token == null) return;
    await _connec.collection("users").doc(userId).set({
      "fcmToken": token,
      "profession": professions,
    }, SetOptions(merge: true));
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

class Accept {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;
  static List<dynamic> datas = [];
  static Future<List<dynamic>> getList() async => datas;
  static Future<void> create(
    String? userIdU,
    String? emailU,
    String userId,
    int like,
    int dislike,
    String profesion,
    String experiencia,
    String descripcion,
    String cell,
  ) async {
    final userDoc = await _connec.collection("users").doc("aceptadas").get();
    if (!userDoc.exists) {
      await _connec
          .collection("users")
          .doc("aceptadas")
          .set({}); //creo el documento vacio
    }
    if (userIdU != null && emailU != null) {
      final Map<String, dynamic> data = {
        "userId": userId,
        "like": like,
        "dislike": dislike,
        "profesion": profesion,
        "experiencia": experiencia,
        "descripcion": descripcion,
        "cell": cell,
      };
      await _connec
          .collection("users")
          .doc("aceptadas")
          .collection(emailU)
          .doc(userIdU)
          .set(data, SetOptions(merge: true));
      //.add(data);
    }
  }

  static Future<void> read(String? userId, String? email) async {
    try {
      if (userId != null && email != null) {
        final docSnap = await _connec
            .collection("users")
            .doc("aceptadas")
            .collection(email)
            .doc(userId)
            .get();
        if (docSnap.exists) {
          datas.clear();
          datas.add({"idDoc": docSnap.id, "data": docSnap.data()});
        }
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  static Future<void> delete(String? email, String? userId) async {
    await _connec
        .collection("users")
        .doc("aceptadas")
        .collection(email!)
        .doc(userId)
        .delete();
  }
}

class Like {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;
  static Future<void> createLike(String userId) async {
    final userDoc = await _connec
        .collection("like")
        .doc(userId)
        .collection("likes")
        .doc("likesD")
        .get();
    if (!userDoc.exists) {
      await _connec
          .collection("like")
          .doc(userId)
          .collection("likes")
          .doc("likesD")
          .set({}); //creo el documento vacio
    }
    await _connec
        .collection("like")
        .doc(userId)
        .collection("likes")
        .doc("likesD")
        .set({"like": FieldValue.increment(1)}, SetOptions(merge: true));
  }

  static Future<void> dislike(String userId) async {
    final userDoc = await _connec
        .collection("like")
        .doc(userId)
        .collection("likes")
        .doc("likesD")
        .get();
    if (!userDoc.exists) {
      await _connec
          .collection("like")
          .doc(userId)
          .collection("likes")
          .doc("likesD")
          .set({}); //creo el documento vacio
    }
    await _connec
        .collection("like")
        .doc(userId)
        .collection("likes")
        .doc("likesD")
        .set({"dislike": FieldValue.increment(1)}, SetOptions(merge: true));
  }
}
