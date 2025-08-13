import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quicklick/firebase_options.dart';
import 'package:quicklick/screens/advertisement.dart';
import 'package:quicklick/screens/internet.dart';
import 'package:quicklick/screens/pages.dart';
import 'package:quicklick/screens/politics.dart';
import 'package:quicklick/screens/professional.dart';
import 'package:quicklick/screens/veriffication.dart';
import 'package:quicklick/services/form_info.dart';
import 'package:quicklick/services/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Preferences.initPreferences();
  await PreferencesRegister.initPreferences();
  await PreferencesName.initPreferencesName();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quicklick",
      initialRoute: "/",
      routes: {
        "anuncios": (BuildContext context) => const Anuncios(),
        "professional": (BuildContext context) => const Professional(),
        "personalInfo": (BuildContext context) => const PersonalInfo(),
        "pages": (BuildContext context) => const Pages(),
        "internet": (BuildContext context) => const Internet(),
        "/": (BuildContext context) => const Verification(),
        "politics": (BuildContext context) => const Politics(),
      },
    );
  }
}
