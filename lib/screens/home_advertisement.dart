import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';
import 'package:quicklick/services/preferences.dart';

class HomeAdvertisement extends StatefulWidget {
  const HomeAdvertisement({super.key});

  @override
  State<HomeAdvertisement> createState() => _HomeAdvertisementState();
}

class _HomeAdvertisementState extends State<HomeAdvertisement>
    with AutomaticKeepAliveClientMixin {
  late final Stream<List<Map<String, dynamic>>> _advertisementStream;
  String? _userId;
  String? _email;
  bool isReady = false;

  @override
  bool get wantKeepAlive => true;

  //inicio del ciclo de vida de la aplicacion
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _userId = (await PreferencesRegister.preferences)!;
    _email = (await Preferences.preferences)!;
    if (_userId != null &&
        _userId!.isNotEmpty &&
        _email != null &&
        _email!.isNotEmpty) {
      _advertisementStream = CrudAdvertisement.getAdvertisementStream(
        _userId,
        _email,
      );
      setState(() {
        isReady = true;
      });
    }
  }

  messageConfirm() {
    const snackBar = SnackBar(
      content: Text("Anuncio eliminado con éxito"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  messageError() {
    const snackBar = SnackBar(
      content: Text("No se pudo eliminar el anuncio"),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!isReady) {
      return const Center(child: CircularProgressIndicator());
    }
    return StreamBuilder(
      stream: _advertisementStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                textAlign: TextAlign.center,
                "Mis anuncios",
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
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.startToEnd,
                confirmDismiss: (direction) async {
                  bool result = false;
                  result = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("¿Desea eliminar su anuncio?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, result),
                            child: Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, result = true),
                            child: Text("Confirmar"),
                          ),
                        ],
                      );
                    },
                  );
                  return result;
                },
                onDismissed: (direction) async {
                  String? idDocJob =
                      snapshot.data?[index]["advertisement"]["idDocJob"];
                  String? idDocs = snapshot.data?[index]["idDoc"];

                  if (idDocs != null) {
                    bool delete = await CrudAdvertisement.deleteAdvertisement(
                      _userId,
                      _email,
                      idDocs,
                    );
                    await CrudJob.deleteProfetion(
                      profetion,
                      idDocJob,
                      location,
                    );
                    if (delete) {
                      messageConfirm();
                    }
                  } else {
                    messageError();
                  }
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 5.0),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
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
                        title: Text(
                          textAlign: TextAlign.center,
                          "Busco $profetion",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.red,
                            size: 40.0,
                          ),
                          SizedBox(width: 20.0),
                          Text(
                            "Deslice para borrar",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
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
}
