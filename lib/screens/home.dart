import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiqliq/services/auths.dart';
import 'package:quiqliq/services/preferences.dart';
import 'package:quiqliq/widgets/form_update.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _cell = TextEditingController();

  Container _cellContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _cell,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.update_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Número celular"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Celular",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () async {
              await Preferences.deletePreferences();
              await PreferencesRegister.deletePreferences();
              Auth.signOut();
            },
            icon: Icon(Icons.outbond, size: 30),
          ),
        ],
        centerTitle: true,
        title: Text(
          "Activar usuario",
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Icon(Icons.update, size: 400.0, color: Colors.white),
                FormUpdate(),
                SizedBox(height: 25.0),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      _cellContainer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            final selectPhoto = await StorageImage.takePhoto();
                            if (selectPhoto == null) {
                              return;
                            } else {
                              if (context.mounted) {
                                const snackBar = SnackBar(
                                  content: Text(
                                    "Espere mientras se carga su foto",
                                  ),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
                              }
                              //OBTENGO LA RUTA COMPLETA DEL ARCHIVO PARA QUE PUEDA SER DESCARGADO

                              File file = File(selectPhoto.path);
                              String url =
                                  await StorageImage.uploadImagePublish(file);
                              if (url.isNotEmpty) {
                                await StorageImage.createCollection(
                                  url,
                                  _cell.text,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Imagen cargada")),
                                  );
                                }
                              } else if (url.isEmpty) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error al cargar imagen"),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        },
                        child: Text("Subir publicidad"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StorageImage {
  static final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static String _url = "";

  static Future<String> uploadImagePublish(File file) async {
    //extraer nombre del archivo
    String fileName = file.path.split("/").last;
    //crear estructura o ruta del documento
    final montainRef = _firebaseStorage.ref().child(
      "Fotos_publicidad/$fileName",
    );
    final UploadTask savePhoto = montainRef.putFile(file);
    TaskSnapshot workDone = await savePhoto.whenComplete(() => true);
    if (workDone.state == TaskState.success) {
      _url = await workDone.ref.getDownloadURL();
      return _url;
    } else {
      return "";
    }
  }

  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static final FirebaseFirestore _connec = FirebaseFirestore.instance;

  static Future<bool> createCollection(String? url, String? cell) async {
    try {
      final Map<String, dynamic> data = {"url": url, "cell": cell};

      await _connec.collection("publicidad").add(data);

      return true;
    } catch (e) {
      debugPrint("Error al crear documento: $e");
      return false;
    }
  }
}
