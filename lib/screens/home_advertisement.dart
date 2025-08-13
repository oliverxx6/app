import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class HomeAdvertisement extends StatefulWidget {
  const HomeAdvertisement({super.key});

  @override
  State<HomeAdvertisement> createState() => _HomeAdvertisementState();
}

class _HomeAdvertisementState extends State<HomeAdvertisement> {
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final String userId = (await PreferencesRegister.preferences)!;
    final String email = (await Preferences.preferences)!;
    await CrudAdvertisement.readAdvertisement(userId, email);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CrudAdvertisement.advertisementStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                textAlign: TextAlign.center,
                "El anuncio creado por usted para buscar un profesional será mostrado en esta pantalla",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              textAlign: TextAlign.center,
              "Ups...Algo a ido mal",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text(
              textAlign: TextAlign.center,
              "Espere por favor",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              String? profetion =
                  snapshot.data?[index]["advertisement"]["profetion"];
              String? description =
                  snapshot.data?[index]["advertisement"]["description"];
              String? value = snapshot.data?[index]["advertisement"]["value"];
              String? location =
                  snapshot.data?[index]["advertisement"]["location"];
              if (snapshot.data == null || snapshot.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 2.0,
                    children: [
                      Icon(Icons.signal_wifi_connected_no_internet_4_outlined),
                      Text("Al parecer no hay conexión"),
                    ],
                  ),
                );
              }
              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.alarm_add_sharp,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Busco $profetion",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.read_more_sharp,
                          color: Colors.white,
                        ),
                        title: Text(
                          description!,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.monetization_on_rounded,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Ofrezco $value dolares",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on, color: Colors.white),
                        title: Text(
                          "Sector $location",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade400,
                        thickness: 0.8,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    CrudAdvertisement.dispose();
    super.dispose();
  }
}
