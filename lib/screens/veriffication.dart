import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quicklick/services/auth.dart';
import 'package:quicklick/services/preferences.dart';

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
  bool lastVersion = false;

  // Future<void> _showInstallInstructions(BuildContext context) async {
  //     await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.black,
  //           title: Text("¿Cómo instalar?", style: TextStyle(color: Colors.white)),
  //           content: Text(
  //             "Después de descargar el archivo, ábrelo para instalar. Si ves un mensaje de seguridad, permite la instalación desde fuentes desconocidas.",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text("Entendido", style: TextStyle(fontSize: 20)),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }

  Future<void> _updateVersionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 27, 26, 26),
            elevation: 30,
            //content: Image.asset("assets/logo.png"),
            title: Text(
              "Se encontro una nueva version de la app",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // try {
                  //   final storageRef = FirebaseStorage.instance
                  //       .ref()
                  //       .child("xmeet")
                  //       .child("app-release.apk");
                  //   final downloadUrl = await storageRef.getDownloadURL();
                  //   Future.delayed(
                  //     Duration(seconds: 3),
                  //   ).then((value) => launchUrl(Uri.parse(downloadUrl)));
                  //   context.mounted ? _showInstallInstructions(context) : null;
                  // } catch (e) {
                  //   if (context.mounted) {
                  //     _messageError(context, e.toString());
                  //   }
                  // }
                },
                child: Text("Actualizar", style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showBlockedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 27, 26, 26),
            elevation: 30,
            //content: Image.asset("assets/logo.png"),
            title: Text(
              "Para continuar con el uso de la membresia, comuníquese al WhatsApp: ",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await AuthService.signOut();
                  await Preferences.deletePreferences();
                  await PreferencesRegister.deletePreferences();
                  SystemNavigator.pop();
                },
                child: Text("Salir", style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> initVerification(BuildContext context) async {
    try {
      if ((userId?.isEmpty ?? true) &&
          (email?.isEmpty ?? true) &&
          (name?.isEmpty ?? true)) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "politics",
            (Route<dynamic> route) => false,
          );
          return;
        }
      } else if (veri == false && lastVersion == false) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "pages",
          (Route<dynamic> route) => false,
        );
        return;
      } else {
        await AuthService.signInWithGoogle();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled' && context.mounted) {
        await _showBlockedDialog(context);
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
      await _showBlockedDialog(context);
    } else if (lastVersion && context.mounted) {
      _updateVersionDialog(context);
    } else if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "pages",
        (Route<dynamic> route) => false,
      );
      return;
    }
  }

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

  Future<void> _initPreferences() async {
    email = await Preferences.preferences;
    userId = await PreferencesRegister.preferences;
    name = await PreferencesName.preferencesName;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await _remoteConfig();
      await _initPreferences(); // Espera que se carguen bien los datos locales
      if (mounted) {
        await _verificationAll(context);
      } // Luego continúa con toda la verificación
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
