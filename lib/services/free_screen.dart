import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FreeScreen {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;

  static Future<void> createConfirmJob(
    BuildContext context,
    String email,
    String pago,
    String value,
  ) async {
    try {
      final userDoc = await _connec
          .collection(email)
          .doc("pagoconfirmado")
          .get();
      if (!userDoc.exists) {
        await _connec.collection(email).doc("pagoconfirmado").set({});
      }
      final Map<String, String> datas = {"confirmacion": pago, "pago": value};
      await _connec.collection(email).doc("pagoconfirmado").set(datas);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("ERROR: $e")));
      }
    }
  }

  static Future<void> createConfirmPro(
    BuildContext context,
    String email,
    String election,
  ) async {
    try {
      final userDoc = await _connec.collection(email).doc("contratado").get();
      if (!userDoc.exists) {
        await _connec.collection(email).doc("contratado").set({});
      }
      final Map<String, String> datas = {"confirmacion": election};
      await _connec.collection(email).doc("contratado").set(datas);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("ERROR: $e")));
      }
    }
  }

  static Future<Map<String, dynamic>?> readJobConfirm(String email) async {
    try {
      final docSnapshot = await _connec
          .collection(email)
          .doc("contratado")
          .get();

      if (docSnapshot.exists) {
        return {"idDoc": docSnapshot.id, "data": docSnapshot.data()};
      } else {
        return null; // No existe el documento
      }
    } catch (e) {
      return null; // En caso de error
    }
  }

  static Future<Map<String, dynamic>?> readPayConfirm(String email) async {
    try {
      final docSnapshot = await _connec
          .collection(email)
          .doc("pagoconfirmado")
          .get();

      if (docSnapshot.exists) {
        return {"idDoc": docSnapshot.id, "data": docSnapshot.data()};
      } else {
        return null; // No existe el documento
      }
    } catch (e) {
      return null; // En caso de error
    }
  }

  static Future<void> deleteJobConfirm(String email) async {
    try {
      await _connec.collection(email).doc("pagoconfirmado").delete();
    } catch (e) {
      e;
    }
  }

  static Future<void> deleteConfirmElection(String email) async {
    try {
      await _connec.collection(email).doc("contratado").delete();
    } catch (e) {
      e;
    }
  }
}
