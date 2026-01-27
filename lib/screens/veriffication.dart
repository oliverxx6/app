import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:quiqliq/services/auth.dart';
import 'package:quiqliq/services/preferences.dart';
import 'package:quiqliq/widgets/dialog_method.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _Verification();
}

class _Verification extends State<Verification> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  String? userId;
  String? email;
  String? name;
  bool veri = false;

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
      if (context.mounted) {
        initVerification(context);
      }
    }
  }

  Future<void> initVerification(BuildContext context) async {
    try {
      if ((userId?.isEmpty ?? true) &&
          (email?.isEmpty ?? true) &&
          (name?.isEmpty ?? true)) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "inicio1",
            (Route<dynamic> route) => false,
          );
          return;
        }
      } else if (veri == false) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "pages",
          (Route<dynamic> route) => false,
        );
        return;
      } else if (veri) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "pages",
          (Route<dynamic> route) => false,
        );
      } else {
        await AuthService.signInWithGoogle();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled' && context.mounted) {
        await DialogMethod.showBlockedDialog(context);
        return;
      } else {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "politics",
            (Route<dynamic> route) => false,
          );
          return;
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "internet",
          (Route<dynamic> route) => false,
        );
      }
      e;
    }
    final bool status = await AuthService.checkUserStatus();
    if (status && context.mounted) {
      await DialogMethod.showBlockedDialog(context);
    }
  }

  Future<void> _initPreferences() async {
    email = await Preferences.preferences;
    userId = await PreferencesRegister.preferences;
    name = await PreferencesName.preferencesName;
    if (email == null || email!.isEmpty) {
      debugPrint("aqui hay un null $email");
    }
    debugPrint("$email");
    debugPrint("$userId");
    debugPrint("$name");
  }

  Future<void> _remoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      debugPrint("aqui el remote configurebbbbbbbb $remoteConfig");
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: Duration(hours: 1),
        ),
      );

      final bool activated = await remoteConfig.fetchAndActivate();
      if (!activated) {
        debugPrint("⚠️ Remote Config no se activó correctamente");
      }
      if (!remoteConfig.getAll().containsKey("pay")) {
        debugPrint("⚠️ Clave 'pay' no existe en Remote Config");
        return;
      }

      final String veripay = remoteConfig.getString("pay");
      debugPrint("&AQUI EL REMOTE $veripay");
      final String verificationPay = "verificado";
      if (veripay.isEmpty) {
        debugPrint("⚠️ 'pay' no está definido en Remote Config");
      }
      if (veripay != verificationPay) {
        veri = true;
      }
    } catch (e, stack) {
      debugPrint("❌ Error en Remote Config: $e");
      debugPrint("📌 Stack trace: $stack");
    }
  }

  Future<void> _startVerificationFlow() async {
    try {
      await _remoteConfig();
      await _initPreferences();
      if (mounted) await _verificationAll(context);
    } catch (e) {
      debugPrint("❌ Error en verificación: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _startVerificationFlow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
