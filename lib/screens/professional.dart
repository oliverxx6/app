import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/form_professional.dart';
import 'package:quicklick/services/picker_image.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:quicklick/services/storage.dart';

class Professional extends StatefulWidget {
  const Professional({super.key});

  @override
  State<Professional> createState() => _Professional();
}

class _Professional extends State<Professional> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  final List<String> _options = [
    "Pintor",
    "Electricista",
    "Fontanero",
    "Cerrajero",
    "Carpintero",
    "Mecánico",
    "Técnico de linea blanca",
  ];
  String? selections;
  String _userId = "";
  String _email = "";
  File? _selectedImage;
  final TextEditingController _profetionalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initAll();
  }

  Future<void> initAll() async {
    _email = (await Preferences.preferences)!;
    _userId = (await PreferencesRegister.preferences)!;
  }

  void messageUpload() {
    const snackBar = SnackBar(
      content: Text("Espere mientras se carga su foto"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void messageError() {
    const snackBar = SnackBar(
      content: Text("Algo salió mal"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void messageSucces() {
    const snackBar = SnackBar(
      content: Text("Foto subida con éxito"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 20.0,
        backgroundColor: _color,
        title: Text(
          "Quicklick Emprendedor",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                textAlign: TextAlign.center,
                "En esta seccion podrás crear un perfil con lo que tú sabes hacer para que puedas recibir ofertas laborales que vayan con tu profesión",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                textAlign: TextAlign.center,
                "1) Escoje una profesión",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              DropdownButton<String>(
                dropdownColor: Colors.black87,
                value: selections,
                hint: Text(
                  "Elige una opción",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                items: _options.map((String values) {
                  return DropdownMenuItem(
                    value: values,
                    child: Text(
                      values,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) => setState(() {
                  selections = newValue;
                  _profetionalController.text = newValue ?? "Sin profesión";
                }),
              ),
              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.justify,
                "2) Toque el siguiente recuadro para poder escojer una fotografía que pueda ser útil para que conozcan su trabajo",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 400.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white54,
                ),
                child: GestureDetector(
                  onTap: () async {
                    final selectPhoto = await ImagePic.takePhoto();
                    if (selectPhoto == null) {
                      return;
                    } else {
                      messageUpload();
                      File file = File(selectPhoto.path);

                      setState(() {
                        _selectedImage = File(selectPhoto.path);
                      });

                      bool succeful = await PhotoStorage.uploadPhotoInStorage(
                        _userId,
                        _email,
                        file,
                      );
                      if (succeful) {
                        messageUpload();
                        String filename = selectPhoto.path.split("/").last;
                        String urls = PhotoStorage.getUrl();
                        bool updateGood =
                            await CreateDBPhoto.createCollectionPhoto(
                              _userId,
                              _email,
                              urls,
                              filename,
                            );
                        if (updateGood) {
                          await CreateDBPhoto.readPhoto(_userId, _email);
                          messageSucces();
                        } else {
                          messageError();
                          try {
                            PhotoStorage.deletePhoto(_userId, _email, filename);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Verifica tu conexion a internet $e",
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      }
                    }
                  },
                  child: Center(
                    child: _selectedImage != null
                        ? Image(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.photo_camera_front_rounded,
                                  size: 120.0,
                                  color: Colors.black38,
                                ),
                              );
                            },
                          )
                        : const Icon(
                            Icons.photo_camera_front_rounded,
                            size: 120.0,
                            color: Colors.black38,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Text(
                "3) Ingresa tus datos para que puedan conocerte",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              ProfessionalInfo(profetionalController: _profetionalController),
            ],
          ),
        ),
      ),
    );
  }
}
