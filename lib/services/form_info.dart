import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _recomendation = TextEditingController();
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  String? _userId;
  String? _email;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  Future<void> _initValues() async {
    try {
      _userId = await PreferencesRegister.preferences;
      _email = await Preferences.preferences;

      if (_userId == null || _email == null) return;

      await Crud.readInfo(_userId!, _email!);

      if (Crud.iddoc.isNotEmpty &&
          Crud.iddoc[0]["data"] != null &&
          Crud.iddoc[0]["data"]["Nombre"] != null) {
        final name = Crud.iddoc[0]["data"]["Nombre"];
        if (name.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) => goPage());
        }
      }
    } catch (e) {
      debugPrint("Error en _initValues: $e");
    }
  }

  void goPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "pages", (route) => false);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_isSubmitting) return;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isSubmitting = true);
      await Crud.createCollection(
        _userId,
        _email,
        _name.text,
        _lastName.text,
        _age.text,
        _id.text,
        _phone.text,
        _recomendation.text,
      );
      if (mounted) setState(() => _isSubmitting = false);
      goPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
      appBar: AppBar(
        centerTitle: true,
        elevation: 20.0,
        backgroundColor: _color,
        title: Text(
          "Registro de Usuario",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.person_2_rounded, color: Colors.white, size: 150),
                _nameContainer(),
                _lastNameContainer(),
                _ageContainer(),
                _idContainer(),
                _phoneNumberContainer(),
                SizedBox(height: 12.0),
                Text(
                  "En este recuadro debe agregar a la persona que le recomendo usar esta plataforma",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 12.0),
                _recomendationContainer(),
                ElevatedButton(
                  onPressed: () async {
                    await _submitForm();
                  },
                  child: Text(
                    "Registrarse",
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _nameContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _name,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.person),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese su nombre"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su nombre",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _lastNameContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _lastName,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.person),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese su apellido"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su apellido",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _ageContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _age,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 2,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.date_range_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese su edad"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su edad",
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return "Este campo no puede estar vacío";
          }
          if (value.length < 2) {
            return "Debe tener al menos 2 caracteres";
          }
          return null;
        },
      ),
    );
  }

  Container _idContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _id,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 10,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.card_membership_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese su número de cédula"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su número de cédula",
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return "Ingrese su número de celular";
          }
          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
            return "Debe tener 10 dígitos numéricos";
          }
          return null;
        },
      ),
    );
  }

  Container _phoneNumberContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _phone,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 10,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.phone_android),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese su número celular"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su número de celular",
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return "Ingrese su número de celular";
          }
          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
            return "Debe tener 10 dígitos numéricos";
          }
          return null;
        },
      ),
    );
  }

  Container _recomendationContainer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _recomendation,
        keyboardType: TextInputType.text,
        maxLength: 10,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.recommend),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese el nombre del recomendador"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese el nombre del recomendador",
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return "Ingrese el nombre del recomendador";
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _lastName.dispose();
    _id.dispose();
    _age.dispose();
    _phone.dispose();
    _recomendation.dispose();
    super.dispose();
  }
}
