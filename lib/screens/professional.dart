import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiqliq/services/crud.dart';
import 'package:quiqliq/services/form_professional.dart';
import 'package:quiqliq/services/pick.dart';
import 'package:quiqliq/services/preferences.dart';
import 'package:quiqliq/services/professions.dart';
import 'package:quiqliq/services/storage.dart';
import 'package:quiqliq/widgets/dialog_method.dart';

class Professional extends StatefulWidget {
  const Professional({super.key});

  @override
  State<Professional> createState() => _Professional();
}

class _Professional extends State<Professional> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  late Professions _professions;
  bool _isLoading = false;
  String _url = "";
  String? _urlGet;

  String _filename = "";
  String _userId = "";
  String? city;
  final TextEditingController _professionalController = TextEditingController();
  final TextEditingController _professionalControllerTwo =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  List<Map<String, dynamic>> fileAndUrl = [];
  @override
  void initState() {
    super.initState();
    _professions = Professions();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    try {
      _userId = (await PreferencesRegister.preferences)!;

      final email = await Preferences.preferences;

      if (email == null || email.isEmpty) {
        debugPrint("No se encontró email en Preferences");
        return;
      }

      // Manejo del stream sin firstOrNull
      final stream = CrudProfessional.getProfessionalStream(_userId, email);

      // Usando try/catch para capturar si el stream está vacío
      fileAndUrl = await stream.first;
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(_userId)
          .collection(email)
          .doc("profesiones")
          .collection("profesion")
          .doc("perfil")
          .get();
      if (doc.exists) {
        setState(() {
          _urlGet = doc.data()?["Url"];
        });
        debugPrint("URL cargada correctamente: $_urlGet");
      } else {
        debugPrint("No existe documento perfil");
      }

      debugPrint("Datos cargados correctamente: $fileAndUrl");
    } catch (e) {
      // Si el stream está vacío o ocurre algún error
      debugPrint("Error al obtener datos de CrudProfessional: $e");
      fileAndUrl = []; // o algún valor por defecto
    }
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
          "Mi Perfil",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                textAlign: TextAlign.center,
                "Crea tu perfil profesional o actividad laboral para recibir ofertas de empleo",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                textAlign: TextAlign.center,
                "1) Tu foto de perfíl",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Center(
                child: (_urlGet?.isEmpty ?? true)
                    ? ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.blue),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (fileAndUrl.isNotEmpty) {
                                  final profession =
                                      fileAndUrl[0]["profession"];
                                  if (profession != null &&
                                      profession["Archivo"] != null) {
                                    final String nameFile =
                                        profession["Archivo"];
                                    await PhotoStorage.deletePhoto(
                                      _userId,
                                      nameFile,
                                    );
                                    debugPrint("Archivo eliminado: $nameFile");
                                  } else {
                                    debugPrint(
                                      "No se encontró 'Archivo' en profession",
                                    );
                                  }
                                } else {
                                  debugPrint("fileAndUrl está vacío o nulo");
                                }

                                //AQUI SELECCIONO EL ARCHIVO QUE ME DEVUELVE IMAGE PICKER
                                final selectPhoto = await ImagePic.takePhoto();
                                if (selectPhoto == null) {
                                  return;
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (context.mounted) {
                                    DialogMethod.messageUpload(context);
                                  }

                                  //OBTENGO LA RUTA COMPLETA DEL ARCHIVO PARA QUE PUEDA SER DESCARGADO

                                  Uint8List imageData = await selectPhoto
                                      .readAsBytes();
                                  //AQUI EXTRAIGO SOLO EL NOMBRE DEL ARCHIVO
                                  final String file = selectPhoto.name;
                                  //PASO EL EMAIL Y LA RUTA DEL ARCHIVO COMPLETA A LA CLASE PHOTOSTORAGE

                                  final videoUpload =
                                      await PhotoStorage.uploadPhotoInStorage(
                                        _userId,
                                        file,
                                        imageData,
                                      );
                                  if (videoUpload) {
                                    _filename = selectPhoto.path
                                        .split("/")
                                        .last;
                                    //OBTENGO EL URL DE LA IMAGEN SUBIDA QUE ME DEVUELVE STORAGE
                                    _url = PhotoStorage.getUrl();
                                    //print("aqui esta el url de descarga $url");
                                    //GUARDO EL URL DEVUELTO Y GUARDO LA REFERENCIA DEL ARCHIVO(EJEMPLO.PNG)
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (context.mounted) {
                                      DialogMethod.messageSucces(context);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      DialogMethod.messageErrors(context);
                                    }
                                    try {
                                      PhotoStorage.deletePhoto(
                                        _userId,
                                        _filename,
                                      );
                                      if (context.mounted) {
                                        DialogMethod.messageErrors(context);
                                      }

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Verifica tu conexión a internet $e",
                                            ),
                                          ),
                                        );
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                }
                              },
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.photo_album,
                                color: Colors.black,
                                size: 20.0,
                              ),
                      )
                    : Text("Ya tiene una foto de perfil"),
              ),
              SizedBox(height: 12.0),
              Text(
                textAlign: TextAlign.center,
                "2) Profesión 1",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: DropdownMenu<String>(
                  label: const Text(
                    "Elija a su profesional",
                    style: TextStyle(color: Colors.white),
                  ),
                  keyboardType: TextInputType.text,
                  enableFilter: true,
                  menuHeight: 200.0,
                  requestFocusOnTap: true,
                  textStyle: const TextStyle(color: Colors.white),
                  dropdownMenuEntries: _professions
                      .professions()
                      .map(
                        (String profess) =>
                            DropdownMenuEntry(value: profess, label: profess),
                      )
                      .toList(),
                  onSelected: (String? value) => setState(() {
                    _professionalController.text = value!;
                  }),
                ),
              ),
              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                "3) Profesión 2 (opcional)",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: DropdownMenu<String>(
                  label: const Text(
                    "Escoja su profesión",
                    style: TextStyle(color: Colors.white),
                  ),
                  enableFilter: true,
                  menuHeight: 200.0,
                  keyboardType: TextInputType.text,
                  requestFocusOnTap: true,
                  textStyle: const TextStyle(color: Colors.white),
                  dropdownMenuEntries: _professions
                      .professions()
                      .map(
                        (String profess) =>
                            DropdownMenuEntry(value: profess, label: profess),
                      )
                      .toList(),
                  onSelected: (String? value) => setState(() {
                    _professionalControllerTwo.text = value!;
                  }),
                ),
              ),

              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                "4) Elige tu ciudad",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Colors.black87,
                value: city,
                hint: Text(
                  "Elige una opción",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                items: _professions.city().map((String values) {
                  return DropdownMenuItem(
                    value: values,
                    child: Text(
                      values,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) => setState(() {
                  city = newValue;
                  _cityController.text = newValue ?? "Sin elección";
                }),
              ),
              SizedBox(height: 12),
              Text(
                "5) Ingresa tus datos",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              (_urlGet?.isEmpty ?? true)
                  ? ProfessionalInfo(
                      professionalController: _professionalController,
                      professionalControllerTwo: _professionalControllerTwo,
                      cityController: _cityController,
                      url: _url,
                      fileName: _filename,
                    )
                  : ProfessionalInfo(
                      professionalController: _professionalController,
                      professionalControllerTwo: _professionalControllerTwo,
                      cityController: _cityController,
                      url: _urlGet!,
                      fileName: _filename,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
