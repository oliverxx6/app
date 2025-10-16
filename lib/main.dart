import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:quicklick/firebase_options.dart';
import 'package:quicklick/screens/advertisement.dart';
import 'package:quicklick/screens/internet.dart';
import 'package:quicklick/screens/pages.dart';
import 'package:quicklick/screens/pay.dart';
import 'package:quicklick/screens/politics.dart';
import 'package:quicklick/screens/professional.dart';
import 'package:quicklick/screens/screen_jobs.dart';
import 'package:quicklick/screens/veriffication.dart';
import 'package:quicklick/services/form_info.dart';
import 'package:quicklick/services/preferences.dart';

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
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<String>? _tokenSubscription;
  bool _isListenerRegistered = false;

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
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    if (!_isListenerRegistered) {
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      _isListenerRegistered = true;
    }
  }

  void _handleMessage(RemoteMessage message) {
    navigatorKey.currentState?.pushNamed('pageJob');
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
      initialRoute: "/",
      routes: {
        "anuncios": (BuildContext context) => const Anuncios(),
        "professional": (BuildContext context) => const Professional(),
        "personalInfo": (BuildContext context) => const PersonalInfo(),
        "pages": (BuildContext context) => const Pages(),
        "internet": (BuildContext context) => const Internet(),
        "/": (BuildContext context) => const Verification(),
        "politics": (BuildContext context) => const Politics(),
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
