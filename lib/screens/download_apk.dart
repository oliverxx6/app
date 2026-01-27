import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadApk extends StatelessWidget {
  const DownloadApk({super.key});

  void messageError(BuildContext context, String e) {
    final snackBar = SnackBar(
      content: Text("Ocurrio un error : $e"),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text("Zona de descarga", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              "App para usarios",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              "Al descargar esta app podrás obtener una mejor experiencia de uso",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              "Solo plataformas Android",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  final storageRef = FirebaseStorage.instance.ref().child(
                    "app-release.apk",
                  );
                  final downloadUrl = await storageRef.getDownloadURL();
                  launchUrl(Uri.parse(downloadUrl));
                } catch (e) {
                  if (context.mounted) {
                    messageError(context, e.toString());
                  }
                }
              },
              child: Text("Descargar app usuario"),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
