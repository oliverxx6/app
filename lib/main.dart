import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quicklick/firebase_options.dart';
import 'package:quicklick/screens/advertisement.dart';
import 'package:quicklick/screens/inicio_1.dart';
import 'package:quicklick/screens/inicio_2.dart';
import 'package:quicklick/screens/internet.dart';
import 'package:quicklick/screens/pages.dart';
import 'package:quicklick/screens/pay.dart';
import 'package:quicklick/screens/politics.dart';
import 'package:quicklick/screens/professional.dart';
import 'package:quicklick/screens/screen_jobs.dart';
import 'package:quicklick/screens/veriffication.dart';
import 'package:quicklick/services/form_info.dart';
import 'package:quicklick/services/preferences.dart';

//NOTA RECORDAR MAS ADELANTE CREAR UN CONTADOR DE USUARIOS EN LINEA Y GPS DE UBICACION
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Preferences.initPreferences();
  await PreferencesRegister.initPreferences();
  await PreferencesName.initPreferencesName();
  await PreferencesJob.initPreferencesJob();
  await PreferencesCity.initPreferencesCity();
  await PreferencesJobTwo.initPreferencesJob();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // Capturamos el mensaje inicial si la app estaba terminada
  RemoteMessage? initialMessage = await FirebaseMessaging.instance
      .getInitialMessage();
  runApp(MyApp(initialMessage: initialMessage));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const MyApp({super.key, this.initialMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<String>? _tokenSubscription;
  bool _isListenerRegistered = false;
  String _initialRoute = "/";

  Future<void> initFCMToken() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //final fcmToken = await FirebaseMessaging.instance.getToken();
    //print("Aqui el token de mi dispositivo..... $fcmToken");
  }

  Future<void> setupInteractedMessage() async {
    // Manejo de mensajes cuando la app está en background
    if (!_isListenerRegistered) {
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      _isListenerRegistered = true;
    }
  }

  void _handleMessage(RemoteMessage message) {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(
        builder: (_) => const Pages(initialIndex: 2),
      ), // 👈 Jobs tab
    );
  }

  Future<void> listenFCMTokenRefresh() async {
    _tokenSubscription?.cancel(); // Cancela si ya existe
    _tokenSubscription = FirebaseMessaging.instance.onTokenRefresh.listen((
      newToken,
    ) async {
      final userId = await PreferencesRegister.preferences;
      if (userId != null && userId.isNotEmpty && newToken.isNotEmpty) {
        await FirebaseFirestore.instance.collection("users").doc(userId).set({
          "fcmToken": newToken,
        }, SetOptions(merge: true));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null) {
      // Si la notificación pide ir directo a Jobs
      _initialRoute = "pages";
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initFCMToken();
      await listenFCMTokenRefresh();
      setupInteractedMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Quicklick",
      initialRoute: _initialRoute,
      routes: {
        "anuncios": (BuildContext context) => const Anuncios(),
        "professional": (BuildContext context) => const Professional(),
        "personalInfo": (BuildContext context) => const PersonalInfo(),
        "pages": (BuildContext context) =>
            Pages(initialIndex: widget.initialMessage != null ? 2 : 0),
        "internet": (BuildContext context) => const Internet(),
        "/": (BuildContext context) => const Verification(),
        "politics": (BuildContext context) => const Politics(),
        "inicio1": (BuildContext context) => const Inicio1(),
        "inicio2": (BuildContext context) => const Inicio2(),
        "pageJob": (BuildContext context) => const Jobs(),
        "pay": (BuildContext context) => const Pay(),
      },
    );
  }

  @override
  void dispose() {
    _tokenSubscription?.cancel();
    super.dispose();
  }
}
