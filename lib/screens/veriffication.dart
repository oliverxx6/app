import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quicklick/services/auth.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:quicklick/widgets/dialog_method.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _Verification();
}

class _Verification extends State<Verification> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  String? userId;
  String? email;
  String? name;
  bool veri = false;
  bool lastVersion = false;

  //Este metodo primero verifica si hay conexxion  internet
  Future<void> _verificationAll(BuildContext context) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "internet",
          (Route<dynamic> route) => false,
        );
      }
    } else {
      final GoogleSignIn signIn = GoogleSignIn.instance;
      unawaited(
        signIn.initialize(
          clientId:
              "316360509652-rtd6vktd9hvem850alstgj3r35d7tj0k.apps.googleusercontent.com",
          serverClientId:
              "316360509652-mlit7st390ael49qrg9crauf339mjnsb.apps.googleusercontent.com",
        ),
      );
      if (context.mounted) {
        initVerification(context);
      }
    }
  }

  Future<void> initVerification(BuildContext context) async {
    try {
      if ((userId?.isEmpty ?? true) &&
          (email?.isEmpty ?? true) &&
          (name?.isEmpty ?? true)) {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "politics",
            (Route<dynamic> route) => false,
          );
          return;
        }
      } else if (veri == false && lastVersion == false) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "pages",
          (Route<dynamic> route) => false,
        );
        return;
      } else if (veri || lastVersion) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "pages",
          (Route<dynamic> route) => false,
        );
      } else {
        await AuthService.signInWithGoogle();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled' && context.mounted) {
        await DialogMethod.showBlockedDialog(context);
        return;
      } else {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "politics",
            (Route<dynamic> route) => false,
          );
          return;
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "internet",
          (Route<dynamic> route) => false,
        );
      }
      e;
    }
    final bool status = await AuthService.checkUserStatus();
    if (status && context.mounted) {
      await DialogMethod.showBlockedDialog(context);
    } else if (lastVersion && context.mounted) {
      await DialogMethod.updateVersionDialog(context);
    }
  }

  Future<void> _initPreferences() async {
    email = await Preferences.preferences;
    userId = await PreferencesRegister.preferences;
    name = await PreferencesName.preferencesName;
  }

  Future<String> getInstalledVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> _remoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: Duration(hours: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();

    final String veripay = remoteConfig.getString("pay");
    final String verificationPay = "verificado";
    if (veripay != verificationPay) {
      veri = true;
    }

    final String latestVersion = remoteConfig.getString("last_version");
    final currentVersion = await getInstalledVersion();
    if (latestVersion != currentVersion) {
      lastVersion = true;
    }
  }

  Future<void> _initIsNotWeb() async {
    await _remoteConfig();
    await _initPreferences();
    if (mounted) await _verificationAll(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _initIsNotWeb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
