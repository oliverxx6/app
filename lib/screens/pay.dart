import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  bool showImage = false;
  @override
  void initState() {
    super.initState();
    imageInitial();
  }

  Future<void> imageInitial() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        showImage = true;
      });
    }
  }

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
          "Espacio Publicitario",
          style: TextStyle(fontSize: 25.0, color: Colors.white),
        ),
      ),
      body: showImage == false
          ? SizedBox.expand(
              child: Image.asset("assets/imagen_pago.jpeg", fit: BoxFit.cover),
            )
          : FutureBuilder(
              future: NewsPapers.readNewsPapers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "No hay datos que mostrar",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Ocurrio un error",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      String url = snapshot.data?[index]["data"]["url"];
                      String phone = snapshot.data?[index]["data"]["cell"];
                      return GestureDetector(
                        onTap: () async {
                          String number = phone;
                          String phoneNumber = number.startsWith("0")
                              ? "593${number.substring(1)}"
                              : number;
                          String message = "Hola, deseo más información";
                          Uri url = Uri.parse(
                            "https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}",
                          );
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "No fue posible abrir whatsapp",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            url,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 50.0,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}

class NewsPapers {
  static final FirebaseFirestore _connec = FirebaseFirestore.instance;

  static Future<List<Map<String, dynamic>>?> readNewsPapers() async {
    List<Map<String, dynamic>> publish = [];
    try {
      final doc = await _connec.collection("publicidad").get();
      for (var i in doc.docs) {
        Map<String, dynamic> docs = {"idDoc": i.id, "data": i.data()};
        publish.add(docs);
      }
      return publish;
    } catch (e) {
      debugPrint("El error al cargar la publicidad es: $e");
      return [];
    }
  }
}
