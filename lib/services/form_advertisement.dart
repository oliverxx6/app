import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class FormAdvertisement extends StatefulWidget {
  final String? proffetion;
  const FormAdvertisement({super.key, required this.proffetion});

  @override
  State<FormAdvertisement> createState() => _FormAdvertisement();
}

class _FormAdvertisement extends State<FormAdvertisement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _location = TextEditingController();

  String? _userId;
  String? _email;

  @override
  void initState() {
    super.initState();
    _description;
    _value;
    _location;
    _initUserId();
  }

  Future<void> _initUserId() async {
    _userId = await PreferencesRegister.preferences;
    _email = await Preferences.preferences;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _descriptions(),
            _valueJob(),
            _locationJob(),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    await CrudAdvertisement.createAdvertisement(
                      _userId,
                      _email,
                      widget.proffetion,
                      _description.text,
                      _value.text,
                      _location.text,
                    );
                    await CrudAdvertisement.readAdvertisement(_userId, _email);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                }
              },
              child: Text(
                "Crear oferta",
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _descriptions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _description,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.receipt),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("¿Qué deseas que el profesional realice?"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "¿Qué deseas que el profesional realice?",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _valueJob() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _value,
        keyboardType: TextInputType.number,
        maxLength: 4,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.monetization_on_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("¿Cuál es tu presupuesto?"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "¿Cuál es tu presupuesto?",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _locationJob() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _location,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.location_on),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Sector para el que necesita el servicio"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su sector",
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
  void dispose() {
    _description.dispose();
    _value.dispose();
    _location.dispose();
    super.dispose();
  }
}
