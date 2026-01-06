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
  late final TextEditingController _location;
  bool _isSubmitting = false;
  String? _userId;
  String? _email;

  @override
  void initState() {
    super.initState();
    _description;
    _value;
    _location = widget.cityController;
    //_location = widget.cityController;
    //_phone;
    _initUserId();
    _profetional = widget.profetionalController;
    //_profetional = widget.profetionalController;
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
            //_profetionContainer(),
            _descriptions(),
            _valueJob(),
            //_locationJob(),
            //_phoneContainer(),
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
          hint: Text("Se especifico en lo que solicitas"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "¿Detalla lo que el profesional debe relizar?",
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
          hint: Text("Agrega un valor razonable"),
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

  @override
  void dispose() {
    _description.dispose();
    _value.dispose();
    _location.dispose();
    //_phone.dispose();
    super.dispose();
  }
}
