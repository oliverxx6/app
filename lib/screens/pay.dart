import 'package:flutter/material.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Pay extends StatelessWidget {
  const Pay({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = const Color.fromARGB(221, 29, 29, 29);
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 20.0,
        backgroundColor: color,
        title: const Text(
          "QUIQLIQ PAY",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(Icons.monetization_on, size: 125, color: Colors.white),
              Text(
                textAlign: TextAlign.center,
                "Banco Pichincha.",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Text(
                textAlign: TextAlign.center,
                "Cta Cte: 210 024 9212",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Divider(thickness: 5.0),
              Text(
                textAlign: TextAlign.center,
                "Banco Guayaquil.",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Text(
                textAlign: TextAlign.center,
                "Cta Aho: 1778 3853",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              Divider(thickness: 5.0),
              Text(
                textAlign: TextAlign.center,
                "Una vez realizado el pago, enviar el comprobante por medio del siguiente botón",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
              ElevatedButton(
                onPressed: () async {
                  String number = "0967256088";
                  String phoneNumber = number.startsWith("0")
                      ? "593${number.substring(1)}"
                      : number;
                  String email = await Preferences.preferences ?? "";
                  String message = "Hola, envio el comprobante de pago $email";
                  Uri url = Uri.parse(
                    "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}",
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("No fue posible abrir whatsapp"),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  "Enviar comprobante",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
