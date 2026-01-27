import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiqliq/services/auths.dart';
import 'package:quiqliq/services/preferences.dart';

class Verifications extends StatefulWidget {
  const Verifications({super.key});

  @override
  State<Verifications> createState() => _Verification();
}

class _Verification extends State<Verifications> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  String? userId;
  String? email;
  String? name;
  bool veri = false;
  bool lastVersion = false;

  //Este metodo primero verifica si hay conexxion  internet
  Future<void> _verificationAll(BuildContext context) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "internet",
          (Route<dynamic> route) => false,
        );
      }
    } else {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      unawaited(
        signIn.initialize(
          clientId:
              "316360509652-rtd6vktd9hvem850alstgj3r35d7tj0k.apps.googleusercontent.com",
          serverClientId:
              "316360509652-mlit7st390ael49qrg9crauf339mjnsb.apps.googleusercontent.com",
        ),
      );

      if (context.mounted) {
        initVerification(context);
      }
    }
  }

  Future<void> initVerification(BuildContext context) async {
    try {
      if ((userId?.isEmpty ?? true) && (email?.isEmpty ?? true)) {
        await Auth.signInWithGoogle();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "home",
            (Route<dynamic> route) => false,
          );
          return;
        }
      } else {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "home",
            (Route<dynamic> route) => false,
          );
          return;
        }
      }
    } catch (e) {
      debugPrint("❌ Error al actualizar los datos: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Error al iniciar: $e")));
      }
    }
  }

  Future<void> _initPreferences() async {
    email = await Preferences.preferences;
    userId = await PreferencesRegister.preferences;
  }

  Future<void> _initIsNotWeb() async {
    await _initPreferences();
    if (mounted) await _verificationAll(context);
  }

  @override
  void initState() {
    super.initState();
    _initIsNotWeb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
