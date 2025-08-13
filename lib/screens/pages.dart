import 'package:flutter/material.dart';
import 'package:quicklick/screens/home_advertisement.dart';
import 'package:quicklick/screens/home_professional.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:quicklick/widgets/draw.dart';

class Pages extends StatefulWidget {
  const Pages({super.key});

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  final Color _color = const Color.fromARGB(221, 29, 29, 29);
  int push = 0;
  String _userId = "";
  String _email = "";

  String _idDoc = "";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _userId = (await PreferencesRegister.preferences)!;
    _email = (await Preferences.preferences)!;
    await Crud.readInfo(_userId, _email);
    setState(() {
      _idDoc = Crud.iddoc.isNotEmpty ? Crud.iddoc[0]["idDoc"] : "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 20.0,
        backgroundColor: _color,
        title: Text(
          "Quicklick",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      drawer: Draw.draw(context, _email, _userId, _idDoc),
      body: IndexedStack(
        index: push,
        children: [HomeAdvertisement(), HomeProfessional()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 25,
        iconSize: 10,
        type: BottomNavigationBarType.shifting,
        currentIndex: push,
        onTap: (value) {
          setState(() => push = value);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.newspaper, size: 35, color: Colors.white),
            activeIcon: Icon(Icons.newspaper, size: 35, color: Colors.white),
            label: "Anuncios",
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.work, size: 35),
            activeIcon: Icon(Icons.work, size: 35),
            label: "Emprendedor",
          ),
        ],
      ),
    );
  }
}
