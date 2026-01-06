import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/screens/button_sheet.dart';
import 'package:quicklick/services/auth.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
                fontSize: 16,
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
              "Mi Perfil Profesional",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.pushNamed(context, "professional");
              }
            },
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(Icons.newspaper, size: 30, color: Colors.white),
            title: const Text(
              "Contratar un Servicio",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.pushNamed(context, "anuncios");
              }
            },
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(Icons.person_4_sharp, size: 30, color: Colors.white),
            title: const Text(
              "Propuestas Aceptadas",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () async {
              if (context.mounted) {
                Navigator.pop(context);
                await Accept.read(email);
                if (context.mounted) {
                  showModalBottomSheet(
                    context: context,
                    elevation: 20.0,
                    isDismissible: true,
                    enableDrag: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ShowJob(stateSelection: false),
                  );
                }
              }
            },
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(Icons.space_dashboard, size: 30, color: Colors.white),
            title: const Text(
              "Servicios Especiales",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () {
              if (context.mounted) {
                Navigator.pushNamed(context, "pay");
              }
            },
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(
              Icons.support_agent_sharp,
              size: 30,
              color: Colors.white,
            ),
            title: const Text(
              "Soporte",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () async {
              String number = "0961149999";
              String phoneNumber = number.startsWith("0")
                  ? "593${number.substring(1)}"
                  : number;
              String message = "Hola, deseo contar con soporte";
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
          ),
          Divider(thickness: 0.5),
          ListTile(
            leading: Icon(Icons.logout, size: 30, color: Colors.white),
            title: const Text(
              "Cerrar Sesión",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () async {
              await AuthService.signOut();
              await Preferences.deletePreferences();
              await PreferencesRegister.deletePreferences();
              await PreferencesName.deletePreferencesName();
              await PreferencesJob.deletePreferencesJob();
              await PreferencesJobTwo.deletePreferencesJob();
              await PreferencesCity.deletePreferencesCity();

              SystemNavigator.pop();
            },
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              "Patrocinado por Marshall Bank",
              style: TextStyle(color: Colors.white60, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
