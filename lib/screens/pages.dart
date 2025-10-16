import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/screens/home_advertisement.dart';
import 'package:quicklick/screens/home_professional.dart';
import 'package:quicklick/screens/screen_jobs.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:quicklick/widgets/draw.dart';
import 'package:url_launcher/url_launcher.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int push = 0;
  String _userId = "";
  String _email = "";
  String _state = "";
  String _idDoc = "";
  String _name = "";
  String _lastname = "";
  String _age = "";
  String _id = "";
  String _recomendation = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initData(context);
    });
  }

  Future<void> _initData(BuildContext context) async {
    _userId = await PreferencesRegister.preferences ?? "";
    _email = await Preferences.preferences ?? "";
    await Crud.readInfo(_userId, _email);
    await Accept.read(_userId, _email);
    _state = await Crud.iddoc[0]["data"]["estado"] ?? "";
    _name = await Crud.iddoc[0]["data"]["Nombre"] ?? "";
    _lastname = await Crud.iddoc[0]["data"]["Apellido"] ?? "";
    _age = await Crud.iddoc[0]["data"]["Edad"] ?? "";
    _id = await Crud.iddoc[0]["data"]["Cedula"] ?? "";
    _idDoc = await Crud.iddoc[0]["idDoc"] ?? "";
    _recomendation = await Crud.iddoc[0]["data"]["Recomendado"] ?? "";
    if (_state == "pendiente" && context.mounted) {
      _showDialog(context);
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Verificación"),
          content: Text(
            "Debe contactarse al 0967256088 para poder ser verificado y activar su cuenta por favor",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String number = "0967256088";
                String phoneNumber = number.startsWith("0")
                    ? "593${number.substring(1)}"
                    : number;
                String message =
                    "Hola, soy $_name $_lastname, mis datos para la verificación son: email: $_email, id de usuario: $_userId, cédula: $_id, edad: $_age. Fuí recomendado por: $_recomendation, id del documento: $_idDoc";
                Uri url = Uri.parse(
                  "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}",
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No fue posible abrir whatsapp")),
                    );
                  }
                }
              },
              child: Text("Contactarse"),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text("Salir"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: _color,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 20.0,
        backgroundColor: _color,
        title: const Text(
          "QUIQLIQ",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      drawer: Draw.draw(_globalKey, context, _email, _userId, _idDoc),
      body: IndexedStack(
        index: push,
        children: [HomeAdvertisement(), HomeProfessional(), Jobs()],
      ),

      bottomNavigationBar: BottomNavigationBar(
        elevation: 25,
        iconSize: 10,
        type: BottomNavigationBarType.shifting,
        currentIndex: push,
        onTap: (value) {
          if (value >= 0 && value < 3) {
            setState(() => push = value);
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.newspaper, size: 35, color: Colors.white),
            activeIcon: Icon(Icons.newspaper, size: 35, color: Colors.white),
            label: "Anuncios",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.person, size: 35),
            activeIcon: Icon(Icons.work, size: 35),
            label: "Emprendedor",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.work_history, size: 35),
            activeIcon: Icon(Icons.work, size: 35),
            label: "Propuestas",
          ),
        ],
      ),
    );
  }
}
