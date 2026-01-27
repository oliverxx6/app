import 'package:flutter/material.dart';
import 'package:quiqliq/dataBase.dart/db.dart';

class FormUpdate extends StatefulWidget {
  const FormUpdate({super.key});

  @override
  State<FormUpdate> createState() => _FormUpdateState();
}

class _FormUpdateState extends State<FormUpdate> {
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late final TextEditingController _update;
  late final TextEditingController _state;
  late final TextEditingController _idDoc;
  late final TextEditingController _email;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _update = TextEditingController();
    _state = TextEditingController();
    _idDoc = TextEditingController();
    _email = TextEditingController();
  }

  Container _updateContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _update,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.update_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí debe ir el id de usario"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí debe ir el id de usario",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "El campo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _emailContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.update_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí debe ir el email del usario"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí debe ir el email del usario",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _idDocContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _idDoc,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.update_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí debe ir el id del documento"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí debe ir el id del documento",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _stateContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _state,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.update_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí debe poner el mensaje verificado"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí debe poner el mensaje verificado",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  void _clearFormFields() {
    _update.clear();
    _email.clear();
    _idDoc.clear();
    _state.clear();
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      setState(() => _isSubmitting = true);
      bool state = await Db.updateState(
        context,
        _update.text,
        _email.text,
        _idDoc.text,
        _state.text,
      );
      if (state && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Documento actualizado correctamente")),
        );
      }
      _clearFormFields();
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _updateContainer(),
            _emailContainer(),
            _idDocContainer(),
            _stateContainer(),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async => await _submitForm(),
              child: Text("Permitir ingreso"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _update.dispose();
    _state.dispose();
    _idDoc.dispose();
    super.dispose();
  }
}
