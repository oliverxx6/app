import 'package:flutter/material.dart';

class Internet extends StatelessWidget {
  const Internet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Icon(Icons.wifi_off, color: Colors.black, size: 70),
        ),
      ),
    );
  }
}
