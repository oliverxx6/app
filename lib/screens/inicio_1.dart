import 'package:flutter/material.dart';

class Inicio1 extends StatelessWidget {
  const Inicio1({super.key});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        child: SizedBox(
          height: h * 1,
          width: double.infinity,
          child: Image.asset("assets/inicio_2.jpeg", fit: BoxFit.fill),
        ),
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            "inicio2",
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
