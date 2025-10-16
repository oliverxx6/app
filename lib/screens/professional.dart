import 'package:flutter/material.dart';
import 'package:quicklick/services/form_professional.dart';
import 'package:quicklick/services/professions.dart';

class Professional extends StatefulWidget {
  const Professional({super.key});

  @override
  State<Professional> createState() => _Professional();
}

class _Professional extends State<Professional> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  late Professions _professions;

  String? selections;
  String? professionTwo;
  String? city;
  final TextEditingController _professionalController = TextEditingController();
  final TextEditingController _professionalControllerTwo =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _professions = Professions();
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
          "Quiqliq Emprendedor",
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
                "En esta sección podrás crear un perfil con lo que tú sabes hacer para que puedas recibir ofertas laborales que vayan con tu profesión, y si tú tienes una segunda profesión puedes escoger la de la lista y si no simplemente poner ninguna",
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
                isExpanded: true,
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
                  _professionalController.text = newValue ?? "Sin profesión";
                }),
              ),
              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                "2) Escoje una segunda profesión de tenerla",
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
                value: professionTwo,
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
                  professionTwo = newValue;
                  _professionalControllerTwo.text = newValue ?? "Sin profesión";
                }),
              ),
              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.center,
                "3) Escoje una ciudad",
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
                "4) Ingresa tus datos para que puedan conocerte",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              ProfessionalInfo(
                professionalController: _professionalController,
                professionalControllerTwo: _professionalControllerTwo,
                cityController: _cityController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
