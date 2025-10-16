import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:quicklick/services/professions.dart';

class HomeProfessional extends StatefulWidget {
  const HomeProfessional({super.key});

  @override
  State<HomeProfessional> createState() => HomeProfessionalState();
}

class HomeProfessionalState extends State<HomeProfessional>
    with AutomaticKeepAliveClientMixin {
  late Stream<List<Map<String, dynamic>>> _professionalStream;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _cityController;
  late Professions _professions;
  String? cities;
  bool isReady = false;
  String? _userId;
  String? _email;
  String? profession;
  String? professionTwo;
  String? expert;
  String? description;
  String? cell;
  String? city;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initAll();
    _cityController = TextEditingController();
    _professions = Professions();
  }

  Future<void> initAll() async {
    _userId = (await PreferencesRegister.preferences)!;
    _email = (await Preferences.preferences)!;
    if (_userId != null &&
        _userId!.isNotEmpty &&
        _email != null &&
        _email!.isNotEmpty) {
      _professionalStream = CrudProfessional.getProfessionalStream(
        _userId,
        _email,
      );
      setState(() {
        isReady = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!isReady) {
      return const Center(child: CircularProgressIndicator());
    }
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: _professionalStream,
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
              profession = firstItem?["profession"]?["Profesion"];
              professionTwo = firstItem?["profession"]?["ProfesionTwo"];
              expert = firstItem?["profession"]?["Experiencia"];
              description = firstItem?["profession"]?["Descripcion"];
              city = firstItem?["profession"]?["Ciudad"];
              cell = firstItem?["profession"]?["Celular"];
              if (profession == null ||
                  expert == null ||
                  description == null ||
                  cell == null ||
                  city == null) {
                return const Center(child: Text("Datos incompletos"));
              }
              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.black26,
                    ),
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: Colors.white, size: 250.0),
                          DropdownButton<String>(
                            isExpanded: true,
                            dropdownColor: Colors.black87,
                            value: cities,
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
                              cities = newValue;
                              _cityController.text = newValue ?? "Sin elección";
                            }),
                          ),
                          SizedBox(height: 12),
                          Text(
                            textAlign: TextAlign.left,
                            "Profesión: $profession",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            textAlign: TextAlign.left,
                            "Profesión 2: $professionTwo",
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
                          Text(
                            textAlign: TextAlign.justify,
                            "Ciudad: $city",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          _cityContainer(),
                          SizedBox(height: 10.0),
                          ElevatedButton(
                            /////boton de actualizacion de ciudad///////
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                await CrudProfessional.createProfessionalPerfil(
                                  _userId,
                                  _email,
                                  profession,
                                  professionTwo,
                                  _cityController.text,
                                  expert,
                                  description,
                                  cell,
                                );
                                await PreferencesCity.deletePreferencesCity();
                                await PreferencesCity.setCity(
                                  _cityController.text,
                                );
                                _professionalStream =
                                    CrudProfessional.getProfessionalStream(
                                      _userId,
                                      _email,
                                    );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Ciudad actualizada con éxito",
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Actualizar ciudad",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Container _cityContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _cityController,
        readOnly: true,
        enableInteractiveSelection: false,
        focusNode: FocusNode(canRequestFocus: false),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.location_city),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí se mostrará la ciudad actualizada"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí se mostrará la ciudad actualizada",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }
}
