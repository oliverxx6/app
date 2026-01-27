import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiqliq/firebase_options.dart';
import 'package:quiqliq/screens/advertisement.dart';
import 'package:quiqliq/screens/download_apk.dart';
import 'package:quiqliq/screens/home.dart';
import 'package:quiqliq/screens/inicio_1.dart';
import 'package:quiqliq/screens/inicio_2.dart';
import 'package:quiqliq/screens/internet.dart';
import 'package:quiqliq/screens/pages.dart';
import 'package:quiqliq/screens/pay.dart';
import 'package:quiqliq/screens/politics.dart';
import 'package:quiqliq/screens/professional.dart';
import 'package:quiqliq/screens/screen_jobs.dart';
import 'package:quiqliq/screens/veriffication.dart';
import 'package:quiqliq/screens/verifications.dart';
import 'package:quiqliq/services/form_info.dart';
import 'package:quiqliq/services/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Preferences.initPreferences();
  await PreferencesRegister.initPreferences();
  await PreferencesName.initPreferencesName();
  await PreferencesJob.initPreferencesJob();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "QUIQLIQ",
      debugShowCheckedModeBanner: false,
      initialRoute: kIsWeb ? "v" : "/",
      routes: {
        "/": (BuildContext context) => const Verifications(),
        "home": (BuildContext context) => Home(),
        "internet": (BuildContext context) => const Internet(),
        "anuncios": (BuildContext context) => const Anuncios(),
        "professional": (BuildContext context) => const Professional(),
        "personalInfo": (BuildContext context) => const PersonalInfo(),
        "pages": (BuildContext context) => const Pages(),
        "inicio1": (BuildContext context) => const Inicio1(),
        "inicio2": (BuildContext context) => const Inicio2(),
        "v": (BuildContext context) => const Verification(),
        "politics": (BuildContext context) => const Politics(),
        "pageJob": (BuildContext context) => const Jobs(),
        "downloadApk": (BuildContext context) => const DownloadApk(),
        "pay": (BuildContext context) => const Pay(),
      },
    );
  }
}
