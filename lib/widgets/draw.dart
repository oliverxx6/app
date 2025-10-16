import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/screens/button_sheet.dart';
import 'package:quicklick/services/auth.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class Draw {
  static Widget draw(
    GlobalKey<ScaffoldState> globalkey,
    BuildContext context,
    String email,
    String userId,
    String idDoc,
  ) {
    return Drawer(
      surfaceTintColor: Colors.yellow,
      elevation: 25.0,
      backgroundColor: Colors.black87,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Bienvenido",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(
                color: Color.fromARGB(255, 5, 19, 216),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              image: DecorationImage(
                image: AssetImage("assets/quiqlickProfessional.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_3, size: 30, color: Colors.white),
            title: const Text(
              "Perfil profesional",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.pushNamed(context, "professional");
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper, size: 30, color: Colors.white),
            title: const Text(
              "Crear anuncio",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.pushNamed(context, "anuncios");
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.person_4_sharp, size: 30, color: Colors.white),
            title: const Text(
              "Profesionales disponibles",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.pop(context);

                showModalBottomSheet(
                  context: context,
                  elevation: 20.0,
                  isDismissible: true,
                  enableDrag: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ShowJob(),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on, size: 30, color: Colors.white),
            title: const Text(
              "Realizar pago",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.pushNamed(context, "pay");
              }
            },
          ),

          ListTile(
            leading: Icon(Icons.logout, size: 30, color: Colors.white),
            title: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () async {
              await Crud.deleteInfo(userId, email, idDoc);
              await AuthService.signOut();
              await Preferences.deletePreferences();
              await PreferencesRegister.deletePreferences();
              await PreferencesName.deletePreferencesName();
              await PreferencesJob.deletePreferencesJob();
              await PreferencesCity.deletePreferencesCity();
              SystemNavigator.pop();
            },
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "© Quicklick 2025",
              style: TextStyle(color: Colors.white60, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
