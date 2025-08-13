import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quicklick/services/auth.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class Draw {
  static Widget draw(
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
            accountName: Text(
              "Opciones",
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              image: DecorationImage(
                image: NetworkImage(
                  "https://www.bizneo.com/blog/wp-content/uploads/2020/04/trabajar-desde-casa.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_3, size: 30, color: Colors.white),
            title: Text(
              "Emprendedor",
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
            title: Text(
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
            leading: Icon(Icons.update_sharp, size: 30, color: Colors.white),
            title: Text(
              "Actualizar perfil",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () async {},
          ),
          ListTile(
            leading: Icon(Icons.logout, size: 30, color: Colors.white),
            title: Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onTap: () async {
              await Crud.deleteInfo(userId, email, idDoc);
              await AuthService.signOut();
              await Preferences.deletePreferences();
              await PreferencesRegister.deletePreferences();
              await PreferencesName.deletePreferencesName();
              SystemNavigator.pop();
            },
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "© Quicklick 2025",
              style: TextStyle(color: Colors.white60, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
