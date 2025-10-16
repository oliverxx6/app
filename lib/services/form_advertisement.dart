import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class FormAdvertisement extends StatefulWidget {
  final TextEditingController profetionalController;
  final TextEditingController cityController;

  const FormAdvertisement({
    super.key,
    required this.profetionalController,
    required this.cityController,
  });

  @override
  State<FormAdvertisement> createState() => _FormAdvertisement();
}

class _FormAdvertisement extends State<FormAdvertisement> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _profetional;
  final TextEditingController _description = TextEditingController();
  final TextEditingController _value = TextEditingController();
  late TextEditingController _location = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  bool _isSubmitting = false;
  String? _userId;
  String? _email;

  @override
  void initState() {
    super.initState();
    _description;
    _value;
    _location = widget.cityController;
    _phone;
    _initUserId();
    _profetional = widget.profetionalController;
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
            _profetionContainer(),
            _descriptions(),
            _valueJob(),
            _locationJob(),
            _phoneContainer(),
            ElevatedButton(
              onPressed: () async {
                if (_isSubmitting) return;
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (_profetional.text.isEmpty ||
                      _description.text.isEmpty ||
                      _value.text.isEmpty ||
                      _location.text.isEmpty) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Todos los campos son obligatorios"),
                        ),
                      );
                    }
                    return;
                  }

                  setState(() => _isSubmitting = true);
                  try {
                    await CrudJob.createJob(
                      _userId,
                      _email,
                      _profetional.text,
                      _description.text,
                      _value.text,
                      _location.text,
                      _phone.text,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Se presento el siguiente error $e"),
                        ),
                      );
                    }
                  } finally {
                    if (context.mounted) Navigator.pop(context);
                    if (mounted) setState(() => _isSubmitting = false);
                  }
                }
              },
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.black)
                  : Text(
                      "Crear oferta",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Container _profetionContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _profetional,
        readOnly: true,
        enableInteractiveSelection: false,
        focusNode: FocusNode(canRequestFocus: false),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.work),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí se mostrará su profesión"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí se mostrará su profesión",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
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
          icon: Icon(Icons.description),
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
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        readOnly: true,
        enableInteractiveSelection: false,
        focusNode: FocusNode(canRequestFocus: false),
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

  Container _phoneContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _phone,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Solo números
          LengthLimitingTextInputFormatter(10), // Máximo 10 dígitos
        ],
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.phone_android),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese se número de Whatsapp"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su número de Whatsapp",
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "El campo no puede estar vacío";
          }
          if (value.length != 10) {
            return "Debe ingresar exactamente 10 dígitos";
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _description.dispose();
    _value.dispose();
    _location.dispose();
    _phone.dispose();
    super.dispose();
  }
}
