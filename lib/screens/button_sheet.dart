import 'package:flutter/material.dart';
import 'package:quiqliq/services/crud.dart';
import 'package:quiqliq/services/free_screen.dart';
import 'package:quiqliq/services/preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowJob extends StatefulWidget {
  final bool stateSelection;
  const ShowJob({super.key, required this.stateSelection});

  @override
  State<ShowJob> createState() => _ShowJobState();
}

class _ShowJobState extends State<ShowJob> {
  String? _email;

  Future<List<dynamic>>? acceptListData;

  @override
  void initState() {
    super.initState();
    acceptListData = Accept.getList();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _email = (await Preferences.preferences)!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: FutureBuilder(
        future: acceptListData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Espere por favor",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Mira quien aceptó tu propuesta",
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
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "¡Algo ha ido mal!",
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
                final item = snapshot.data![index];
                final userId = item["data"]["userId"];
                final email = item["data"]["email"];
                final value = item["data"]["pay"];
                final profesion = item["data"]["profesion"];
                final profesionDos = item["data"]["profesion2"];
                final doc = item["data"]["doc"];
                final location = item["data"]["location"];
                final job = item["data"]["job"];
                final String url = item["data"]["url"];
                final experiencia = item["data"]["experiencia"];
                final descripcion = item["data"]["descripcion"];
                final cell = item["data"]["cell"];
                final like = item["data"]["like"];
                final jobsQuantity = item["data"]["jobs"];
                final String docId = item["idDoc"];

                return widget.stateSelection == false
                    ? Card(
                        color: Colors.grey[900],
                        margin: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120.0,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: Colors.grey[200],
                                            child: ClipOval(
                                              child: Image.network(
                                                width: 50,
                                                height: 50,
                                                url,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Icon(
                                                        Icons.person,
                                                        size: 15,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: IconButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext dialogContext) {
                                                    return AlertDialog(
                                                      title: Text("Calificar"),
                                                      content: Text(
                                                        "¿Desea darle una estrella?",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                              dialogContext,
                                                            );
                                                            await Like.createLike(
                                                              userId,
                                                            );
                                                            await FreeScreen.deleteConfirmElection(
                                                              _email!,
                                                            );
                                                            await Accept.getList().then((
                                                              list,
                                                            ) async {
                                                              int x =
                                                                  list.length;
                                                              for (
                                                                int i = 0;
                                                                i < x;
                                                                i++
                                                              ) {
                                                                String docId =
                                                                    list[i]["idDoc"];
                                                                await Accept.delete(
                                                                  _email,
                                                                  docId,
                                                                );
                                                              }
                                                            });
                                                            await Accept.read(
                                                              _email,
                                                            );
                                                            setState(() {
                                                              acceptListData =
                                                                  Accept.getList();
                                                            });
                                                          },
                                                          child: Text("Sí"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                              dialogContext,
                                                            );

                                                            await FreeScreen.deleteConfirmElection(
                                                              _email!,
                                                            );

                                                            await Accept.getList().then((
                                                              list,
                                                            ) async {
                                                              int x =
                                                                  list.length;
                                                              for (
                                                                int i = 0;
                                                                i < x;
                                                                i++
                                                              ) {
                                                                String docId =
                                                                    list[i]["idDoc"];
                                                                await Accept.delete(
                                                                  _email,
                                                                  docId,
                                                                );
                                                              }
                                                            });
                                                            await Accept.read(
                                                              _email,
                                                            );
                                                            setState(() {
                                                              acceptListData =
                                                                  Accept.getList();
                                                            });
                                                          },
                                                          child: Text("No"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.star),
                                              color: Colors.yellow,
                                            ),
                                            title: Text(
                                              like.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "($jobsQuantity)",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        textAlign: TextAlign.center,
                                        "$profesion",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      if ((profesionDos ?? "").isNotEmpty)
                                        Text(
                                          "$profesionDos",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),

                                      Text(
                                        "$experiencia años de experiencia",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        descripcion,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        "Sector $location",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),

                                      Wrap(
                                        children: [
                                          Column(
                                            children: [
                                              Wrap(
                                                children: [
                                                  FilledButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateColor
                                                              .transparent,
                                                    ),
                                                    onPressed: () async {
                                                      const String no = "no";
                                                      await FreeScreen.createConfirmJob(
                                                        context,
                                                        email,
                                                        no,
                                                        value,
                                                      );
                                                      await CrudJob.deleteProfetion(
                                                        job,
                                                        doc,
                                                        location,
                                                      );
                                                      if (context.mounted) {
                                                        await FreeScreen.createConfirmJob(
                                                          context,
                                                          email,
                                                          no,
                                                          value,
                                                        );
                                                      }

                                                      if (context.mounted) {
                                                        await FreeScreen.createConfirmPro(
                                                          context,
                                                          _email!,
                                                          no,
                                                        );
                                                      }
                                                      String number = cell;
                                                      String phoneNumber =
                                                          number.startsWith("0")
                                                          ? "593${number.substring(1)}"
                                                          : number;
                                                      String message =
                                                          "Saludos, acabo de contratar tus servicios";
                                                      //"https://wa.me/$phoneNumber/?text=${Uri.encodeComponent(message)}",
                                                      Uri url = Uri.parse(
                                                        "https://api.whatsapp.com/send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}",
                                                      );
                                                      try {
                                                        await launchUrl(
                                                          url,
                                                          mode: LaunchMode
                                                              .externalApplication,
                                                        );
                                                      } catch (e) {
                                                        if (context.mounted) {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                "No fue posible abrir whatsapp error: $e",
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: Text(
                                                      "Contratar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ),
                                                  FilledButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateColor
                                                              .transparent,
                                                    ),
                                                    onPressed: () async {
                                                      await Accept.delete(
                                                        _email,
                                                        docId,
                                                      );
                                                      await Accept.read(_email);
                                                      setState(() {
                                                        acceptListData =
                                                            Accept.getList();
                                                      });
                                                    },
                                                    child: Text(
                                                      "Rechazar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Card(
                        color: Colors.grey[900],
                        margin: EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 120.0,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 25.0,
                                            backgroundColor: Colors.grey[200],
                                            child: ClipOval(
                                              child: Image.network(
                                                width: 50,
                                                height: 50,
                                                url,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Icon(
                                                        Icons.person,
                                                        size: 15,
                                                        color: Colors.grey,
                                                      );
                                                    },
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            leading: IconButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext dialogContext) {
                                                    return AlertDialog(
                                                      title: Text("Calificar"),
                                                      content: Text(
                                                        "¿Desea darle una estrella?",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                              dialogContext,
                                                            );
                                                            await Like.createLike(
                                                              userId,
                                                            );
                                                            await FreeScreen.deleteConfirmElection(
                                                              _email!,
                                                            );
                                                            await Accept.getList().then((
                                                              list,
                                                            ) async {
                                                              int x =
                                                                  list.length;
                                                              for (
                                                                int i = 0;
                                                                i < x;
                                                                i++
                                                              ) {
                                                                String docId =
                                                                    list[i]["idDoc"];
                                                                await Accept.delete(
                                                                  _email,
                                                                  docId,
                                                                );
                                                              }
                                                            });
                                                            await Accept.read(
                                                              _email,
                                                            );
                                                            setState(() {
                                                              acceptListData =
                                                                  Accept.getList();
                                                            });
                                                          },
                                                          child: Text("Sí"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                              dialogContext,
                                                            );
                                                            await FreeScreen.deleteConfirmElection(
                                                              _email!,
                                                            );
                                                            await Accept.getList().then((
                                                              list,
                                                            ) async {
                                                              int x =
                                                                  list.length;
                                                              for (
                                                                int i = 0;
                                                                i < x;
                                                                i++
                                                              ) {
                                                                String docId =
                                                                    list[i]["idDoc"];
                                                                await Accept.delete(
                                                                  _email,
                                                                  docId,
                                                                );
                                                              }
                                                            });
                                                            await Accept.read(
                                                              _email,
                                                            );
                                                            setState(() {
                                                              acceptListData =
                                                                  Accept.getList();
                                                            });
                                                          },
                                                          child: Text("No"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.star),
                                              color: Colors.yellow,
                                            ),
                                            title: Text(
                                              like.toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "($jobsQuantity)",
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        textAlign: TextAlign.center,
                                        "$profesion \n $profesionDos",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        "$experiencia años de experiencia",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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
