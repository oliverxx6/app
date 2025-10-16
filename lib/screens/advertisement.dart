import 'package:flutter/material.dart';
import 'package:quicklick/services/form_advertisement.dart';
import 'package:quicklick/services/professions.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _Anuncios();
}

class _Anuncios extends State<Anuncios> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _city = TextEditingController();
  late Professions _professions;
  String? selections;
  String? cities;
  String urls = "";
  String filename = "";

  @override
  void initState() {
    super.initState();
    _professions = Professions();
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
          "Anuncios Quiqliq",
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
                "En esta seccion podrás crear un anuncio para encontrar un profesional para tu necesidad.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                textAlign: TextAlign.center,
                "1) Escoje al profesional que necesita",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              DropdownButton<String>(
                dropdownColor: Colors.black87,
                isExpanded: true,
                value: selections,
                hint: Text(
                  "Elige una opción",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                items: _professions.professions().map((String values) {
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
                  selections = newValue;
                  _jobController.text = newValue ?? "Sin profesión";
                }),
              ),
              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                "2) Escoja la ciudad donde necesita al profesional",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              DropdownButton<String>(
                dropdownColor: Colors.black87,
                isExpanded: true,
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
                  _city.text = newValue ?? "Sin selección";
                }),
              ),
              Text(
                textAlign: TextAlign.justify,
                "3) LLene los datos solicitados a continuación",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              FormAdvertisement(
                profetionalController: _jobController,
                cityController: _city,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
