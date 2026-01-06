import 'package:flutter/material.dart';

class Inicio2 extends StatelessWidget {
  const Inicio2({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        child: SizedBox(
          height: h * 1,
          width: double.infinity,
          child: Image.asset("assets/inicio_1.jpeg", fit: BoxFit.fill),
        ),
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "politics",
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
