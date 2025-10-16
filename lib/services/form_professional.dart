import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class ProfessionalInfo extends StatefulWidget {
  final TextEditingController professionalController;
  final TextEditingController professionalControllerTwo;
  final TextEditingController cityController;
  const ProfessionalInfo({
    super.key,
    required this.professionalController,
    required this.professionalControllerTwo,
    required this.cityController,
  });

  @override
  State<ProfessionalInfo> createState() => _ProfessionalInfo();
}

class _ProfessionalInfo extends State<ProfessionalInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _professional;
  late final TextEditingController _professionalTwo;
  late final TextEditingController _city;
  final TextEditingController _exper = TextEditingController();
  final TextEditingController _descriptionExper = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  String? _userId;
  String? _email;
  bool _isSubmitting =
      false; //banderas booleanas para impedir pulsaciones repetitivas en los botones

  @override
  void initState() {
    super.initState();
    _initUserId();
    _professional = widget.professionalController;
    _professionalTwo = widget.professionalControllerTwo;
    _city = widget.cityController;
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.work_sharp, color: Colors.white, size: 150),
            _professionContainer(),
            _professionContainerTwo(),
            _cityContainer(),
            _yearsProfetionContainer(),
            _descriptionContainer(),
            _phoneNumberContainer(),
            ElevatedButton(
              /////boton de creacion de perfil///////
              onPressed: () async {
                if (_isSubmitting) return;
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    _isSubmitting = true;
                  });
                  await CrudProfessional.createProfessionalPerfil(
                    _userId,
                    _email,
                    _professional.text,
                    _professionalTwo.text,
                    _city.text,
                    _exper.text,
                    _descriptionExper.text,
                    _phoneNumber.text,
                  );
                  await PreferencesJob.deletePreferencesJob();
                  await PreferencesJobTwo.deletePreferencesJob();
                  await PreferencesCity.deletePreferencesCity();
                  await PreferencesJob.setJob(_professional.text);
                  await PreferencesJobTwo.setJob(_professionalTwo.text);
                  await PreferencesCity.setCity(_city.text);

                  final token = await FirebaseMessaging.instance.getToken();
                  await CrudProfessional.saveFcmToken(
                    _userId,
                    token,
                    _professional.text,
                    _professionalTwo.text,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Perfil registrado con éxito")),
                    );
                    Navigator.pop(context);
                  }
                  if (mounted) setState(() => _isSubmitting = false);
                }
              },
              child: Text(
                "Registrarse",
                style: TextStyle(fontSize: 20.0, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _professionContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _professional,
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

  Container _professionContainerTwo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _professionalTwo,
        readOnly: true,
        enableInteractiveSelection: false,
        focusNode: FocusNode(canRequestFocus: false),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.work),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí se mostrará su segunda profesión"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí se mostrará su segunda profesión",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
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
        controller: _city,
        readOnly: true,
        enableInteractiveSelection: false,
        focusNode: FocusNode(canRequestFocus: false),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.location_city),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Aquí se mostrará su ciudad"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Aquí se mostrará su ciudad",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _yearsProfetionContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _exper,
        maxLength: 2,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.date_range_sharp),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese su años de experiencia"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese su años de experiencia",
        ),
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return "Este campo no puede estar vacío";
          }
          return null;
        },
      ),
    );
  }

  Container _descriptionContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _descriptionExper,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.description),
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          hint: Text("Ingrese una descripción de su experiencia laboral"),
          labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
          labelText: "Ingrese una descripción de su experiencia laboral",
        ),
        validator: (String? value) {
          return value != null && value.isEmpty
              ? "Elcampo no puede estar vacío"
              : null;
        },
      ),
    );
  }

  Container _phoneNumberContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: _phoneNumber,
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

  @override
  void dispose() {
    _exper.dispose();
    _descriptionExper.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }
}
