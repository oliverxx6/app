import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:quicklick/services/storage.dart';

class HomeProfessional extends StatefulWidget {
  const HomeProfessional({super.key});

  @override
  State<HomeProfessional> createState() => _HomeProfessional();
}

class _HomeProfessional extends State<HomeProfessional> {
  String _userId = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    initAll();
  }

  Future<void> initAll() async {
    _userId = (await PreferencesRegister.preferences)!;
    _email = (await Preferences.preferences)!;
    await CreateDBPhoto.readPhoto(_userId, _email);
    await CrudProfessional.readProfetion(_userId, _email);
  }

  messageConfirm() {
    const snackBar = SnackBar(
      content: Text("Foto eliminada con éxito"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  messageError() {
    const snackBar = SnackBar(
      content: Text("No se pudo eliminar la foto"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<dynamic>>(
          stream: CreateDBPhoto.photoStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.error != null) {
              return Center(child: Text("Algo salió mal"));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "El perfil profesional creado por usted será mostrado en esta pantalla",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              final dynamic firstItem = snapshot.data[0];
              final String? url = firstItem?["datos"]?["urlPhoto"];
              final String? nameFile = firstItem?["datos"]?["filePhoto"];

              if (url == null || nameFile == null) {
                return const Center(child: Text("Datos incompletos"));
              }
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  bool result = false;
                  result = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("¿Desea eliminar esta foto?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, result),
                            child: Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, result = true),
                            child: Text("Confirmar"),
                          ),
                        ],
                      );
                    },
                  );
                  return result;
                },
                onDismissed: (direction) async {
                  String? idDocs = snapshot.data?[0]["id"];
                  if (idDocs != null) {
                    bool delete = await PhotoStorage.deletePhoto(
                      _userId,
                      _email,
                      nameFile,
                    );
                    bool deleteCrud = await CreateDBPhoto.deleteDataPhoto(
                      _userId,
                      _email,
                      idDocs,
                    );
                    if (delete && deleteCrud) {
                      messageConfirm();
                      CreateDBPhoto.readPhoto(_userId, _email);
                    }
                  } else {
                    messageError();
                    CreateDBPhoto.readPhoto(_userId, _email);
                  }
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 5.0),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: Icon(
                          Icons.photo_camera_front_rounded,
                          size: 120.0,
                          color: Colors.black38,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 120.0,
                          color: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
        SizedBox(height: 8),
        StreamBuilder(
          stream: CrudProfessional.professionalStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.error != null) {
              return Center(child: Text("Algo salió mal"));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Aquí se mostraran sus datos profesionales",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            } else {
              final dynamic firstItem = snapshot.data[0];
              final String? profetion = firstItem?["datos"]?["Profesion"];
              final String? expert = firstItem?["datos"]?["Experiencia"];
              final String? description = firstItem?["datos"]?["Descripcion"];
              final String? cell = firstItem?["datos"]?["Celular"];

              if (profetion == null ||
                  expert == null ||
                  description == null ||
                  cell == null) {
                return const Center(child: Text("Datos incompletos"));
              }
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.black26,
                    ),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.justify,
                          "Profesión: $profetion",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          textAlign: TextAlign.justify,
                          "Años de experiencia: $expert",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          textAlign: TextAlign.justify,
                          "Descripción: $description",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          textAlign: TextAlign.justify,
                          "Contacto: $cell",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    CreateDBPhoto.disposePhotoStream();
    CrudProfessional.dispose();
    super.dispose();
  }
}
