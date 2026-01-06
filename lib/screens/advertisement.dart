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
  final Professions _professions = Professions();
  List<String> _professionsS = [];
  String? cities;

  String urls = "";
  String filename = "";

  @override
  void initState() {
    super.initState();
    _professionsS = _professions.professions();
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
          "Solicitud de Servicios",
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
                "Solicita aquí tu servicio profesional.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                textAlign: TextAlign.center,
                "1) Escoje al profesional que necesitas",
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
                    "Elija al profesional",
                    style: TextStyle(color: Colors.white),
                  ),
                  keyboardType: TextInputType.text,
                  enableFilter: true,
                  menuHeight: 200.0,
                  requestFocusOnTap: true,
                  textStyle: const TextStyle(color: Colors.white),
                  dropdownMenuEntries: _professionsS
                      .map(
                        (String profess) =>
                            DropdownMenuEntry(value: profess, label: profess),
                      )
                      .toList(),
                  onSelected: (String? value) => setState(() {
                    _jobController.text = value!;
                  }),
                ),
              ),
              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                "2) Ciudad donde necesita al profesional",
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
                "3) LLene los datos a continuación",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              FormAdvertisement(
                profetionalController: _jobController, //_jobController,
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
