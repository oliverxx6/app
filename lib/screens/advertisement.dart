import 'package:flutter/material.dart';
import 'package:quicklick/services/form_advertisement.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _Anuncios();
}

class _Anuncios extends State<Anuncios> {
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
          "Quicklick Anuncios",
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
                onChanged: (String? newValue) =>
                    setState(() => selections = newValue),
              ),
              SizedBox(height: 12),
              Text(
                textAlign: TextAlign.justify,
                "2) LLene los datos solicitados a continuación",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 12),
              FormAdvertisement(proffetion: selections),
            ],
          ),
        ),
      ),
    );
  }
}
