import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DialogMethod {
  static Future<void> showInstallInstructions(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text("¿Cómo instalar?", style: TextStyle(color: Colors.white)),
          content: Text(
            "Después de descargar el archivo, ábrelo para instalar. Si ves un mensaje de seguridad, permite la instalación desde fuentes desconocidas.",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Entendido", style: TextStyle(fontSize: 20)),
            ),
          ],
        );
      },
    );
  }

  static void messageError(BuildContext context, String e) {
    final snackBar = SnackBar(
      content: Text("Ocurrio un error : $e"),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> updateVersionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 27, 26, 26),
            elevation: 30,
            content: Image.asset("assets/1024.png"),
            title: Text(
              "Se encontro una nueva version de la app",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    final storageRef = FirebaseStorage.instance.ref().child(
                      "app-release.apk",
                    );
                    final downloadUrl = await storageRef.getDownloadURL();
                    Future.delayed(
                      Duration(seconds: 3),
                    ).then((value) => launchUrl(Uri.parse(downloadUrl)));
                    context.mounted ? showInstallInstructions(context) : null;
                  } catch (e) {
                    if (context.mounted) {
                      messageError(context, e.toString());
                    }
                  }
                },
                child: Text("Actualizar", style: TextStyle(fontSize: 25)),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showBlockedDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 27, 26, 26),
            elevation: 30,
            content: Image.asset("assets/1024.png"),
            title: Text(
              "Para continuar con el uso de la membresia, comuníquese al WhatsApp: 0967256088",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () async {
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
}
