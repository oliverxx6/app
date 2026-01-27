import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Db {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static Future<bool> updateState(
    BuildContext context,
    String userId,
    String email,
    String idDoc,
    String message,
  ) async {
    try {
      final docRef = _db
          .collection("users")
          .doc(userId)
          .collection(email)
          .doc(idDoc);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        await docRef.update({"estado": message});
        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("⚠️ Documento no encontrado")));
        }

        return false;
      }
    } catch (e) {
      debugPrint("❌ Error al actualizar los datos: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Error al actualizar: $e")));
      }

      return false;
    }
  }

  static Future<void> createCollecion(String userId, String email) async {
    try {
      final userDoc = await _db.collection("users").doc(userId).get();
      if (!userDoc.exists) {
        await _db.collection("users").doc(userId).set({
          "rol": "admin",
          "email": email,
        }); //creo el documento vacio
      } else {
        await _db.collection("users").doc(userId).set({
          "rol": "admin",
          "email": email,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("❌ Error al crear la coleecion los datos: $e");
    }
  }
}
