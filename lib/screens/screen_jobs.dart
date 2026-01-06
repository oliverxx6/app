import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';
import 'package:rxdart/rxdart.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _Jobs();
}

class _Jobs extends State<Jobs> with AutomaticKeepAliveClientMixin {
  late final Stream<List<Map<String, dynamic>>> _jobStream;
  late final Stream<List<Map<String, dynamic>>> _jobStreamTwo;
  late final Stream<List<Map<String, dynamic>>> _combinedStream;
  bool isReady = false;
  String? _userId;
  String? _email;
  int? _like;
  int? _quantityJobs;
  String? profesion;
  String? profesionTwo;
  String? url;
  String? experiencia;
  String? descripcion;
  String? _sector;
  String? cell;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initPreferencesAndCrud();
  }

  Future<void> initPreferencesAndCrud() async {
    _userId = await PreferencesRegister.preferences;
    _email = (await Preferences.preferences)!;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(_userId)
        .collection(_email!)
        .doc("profesiones")
        .collection("profesion")
        .doc("perfil")
        .get();
    if (doc.exists) {
      setState(() {
        _sector = doc.data()?["Sector"];
      });
      debugPrint("URL cargada correctamente: $_sector");
    } else {
      debugPrint("No existe documento perfil");
    }
    final jobPref = await PreferencesJob.preferencesJobs ?? "prueba";
    final jobPrefTwo = await PreferencesJobTwo.preferencesJobs ?? "prueba";
    final job = jobPref.isEmpty ? "prueba" : jobPref;
    final jobTwo = jobPrefTwo.isEmpty ? "prueba" : jobPrefTwo;
    final cityPref = await PreferencesCity.preferencesCities ?? "prueba";
    final city = cityPref.isEmpty ? "prueba" : cityPref;
    if (job != "prueba" && jobTwo != "prueba" && city != "prueba") {
      profesion = job;
      profesionTwo = jobTwo;
      List<Map<String, dynamic>> professionalList =
          await CrudProfessional.getProfessionalStream(_userId, _email).first;
      if (professionalList.isNotEmpty) {
        url = professionalList[0]["profession"]["Url"];
        experiencia = professionalList[0]["profession"]?["Experiencia"];
        descripcion = professionalList[0]["profession"]?["Descripcion"];
        cell = professionalList[0]["profession"]?["Celular"];
      }
      _jobStream = CrudJob.jobStream(job, city);
      _jobStreamTwo = CrudJob.jobStream(jobTwo, city);
      _combinedStream = Rx.combineLatest2(
        _jobStream,
        _jobStreamTwo,
        (List<Map<String, dynamic>> a, List<Map<String, dynamic>> b) => [
          ...a,
          ...b,
        ],
      ); //operador de propagación (...) o spread operator en Dart.

      List likes = await flike(_userId);
      if (likes.isNotEmpty) {
        _like = likes[0]["data"]["like"] ?? 0;
        _quantityJobs = likes[0]["data"]["jobs"] ?? 0;
      } else {
        _like = 0;
        _quantityJobs = 0;
      }

      setState(() => isReady = true);
    } else {
      List<Map<String, dynamic>> professionalList =
          await CrudProfessional.getProfessionalStream(_userId, _email).first;
      if (professionalList.isNotEmpty) {
        profesion = professionalList[0]["profession"]["Profesion"];
        profesionTwo = professionalList[0]["profession"]["ProfesionTwo"];
        String city = professionalList[0]["profession"]["Ciudad"];
        url = professionalList[0]["profession"]["Url"];
        experiencia = professionalList[0]["profession"]?["Experiencia"];
        descripcion = professionalList[0]["profession"]?["Descripcion"];
        cell = professionalList[0]["profession"]?["Celular"];
        _jobStream = CrudJob.jobStream(profesion, city);
        _jobStreamTwo = CrudJob.jobStream(profesionTwo, city);
        _combinedStream = Rx.combineLatest2(
          _jobStream,
          _jobStreamTwo,
          (List<Map<String, dynamic>> a, List<Map<String, dynamic>> b) => [
            ...a,
            ...b,
          ],
        ); //operador de propagación (...) o spread operator en Dart.
        //_userId = await PreferencesRegister.preferences;
        //_email = (await Preferences.preferences)!;
        List likes = await flike(_userId);
        if (likes.isNotEmpty) {
          _like = likes[0]["data"]["like"] ?? 0;
          _quantityJobs = likes[0]["data"]["jobs"] ?? 0;
        } else {
          _like = 0;
          _quantityJobs = 0;
        }
        setState(() => isReady = true);
      } else {
        //profesion = profesionTwo = experiencia = descripcion = cell =
        //  "No disponible";
        _jobStream = CrudJob.jobStream(job, city);
        _jobStreamTwo = CrudJob.jobStream(jobTwo, city);
        _combinedStream = Rx.combineLatest2(
          _jobStream,
          _jobStreamTwo,
          (List<Map<String, dynamic>> a, List<Map<String, dynamic>> b) => [
            ...a,
            ...b,
          ],
        ); //operador de propagación (...) o spread operator en Dart.
        _userId = await PreferencesRegister.preferences;
        _email = (await Preferences.preferences)!;
        List likes = await flike(_userId);
        if (likes.isNotEmpty) {
          _like = likes[0]["data"]["like"] ?? 0;
          _quantityJobs = likes[0]["data"]["jobs"] ?? 0;
        } else {
          _like = 0;
          _quantityJobs = 0;
        }
        setState(() => isReady = true);
      }
    }
  }

  Future<List> flike(String? userId) async {
    final FirebaseFirestore connec = FirebaseFirestore.instance;
    List like = [];
    await connec.collection("like").doc(userId).collection("likes").get().then((
      value,
    ) {
      for (var i in value.docs) {
        final Map<String, dynamic> dataContents;
        dataContents = {"idDoc": i.id, "data": i.data()};
        like.add(dataContents);
      }
    });
    return like;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!isReady) {
      return const Center(child: CircularProgressIndicator());
    }
    return StreamBuilder<List<dynamic>>(
      stream: _combinedStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        } else if (snapshot.error != null) {
          return Center(
            child: Text(
              "Algo salió mal",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                textAlign: TextAlign.center,
                "Entrada de ofertas laborales",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              String? emailUsuario =
                  snapshot.data[index]["profession"]["emailUsuario"];

              String? job = snapshot.data[index]["profession"]["profetion"];
              String? description =
                  snapshot.data[index]["profession"]["description"];
              String? value = snapshot.data[index]["profession"]["value"];
              String? location = snapshot.data[index]["profession"]["location"];
              String? docNumber = snapshot.data[index]["idDoc"];
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
              return Container(
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
                child: GestureDetector(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          textAlign: TextAlign.center,
                          "Se solicita $job",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        subtitle: Text(
                          "Ofrezco: $value dólares \n Ciudad: $location \n $description",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
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
                  onTap: () async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("¿Deseas aceptar el trabajo?"),
                          actions: <TextButton>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (mounted) {
                                  Navigator.pop(context);
                                }

                                await Accept.create(
                                  emailUsuario,
                                  _userId!,
                                  _email!,
                                  value!,
                                  _like!,
                                  _quantityJobs!,
                                  docNumber!,
                                  _sector!,
                                  job!,
                                  profesion!,
                                  profesionTwo ?? "",
                                  url!,
                                  experiencia!,
                                  descripcion!,
                                  cell!,
                                );
                              },
                              child: Text("Si"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
