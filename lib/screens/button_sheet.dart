import 'package:flutter/material.dart';
import 'package:quicklick/services/crud.dart';

class ShowJob extends StatefulWidget {
  const ShowJob({super.key});

  @override
  State<ShowJob> createState() => _ShowJobState();
}

class _ShowJobState extends State<ShowJob> {
  bool isLiked = false;
  bool isDislike = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: FutureBuilder(
        future: Accept.getList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  textAlign: TextAlign.center,
                  "Aquí podrá visualizar quien acepto su propuesta de empleo",
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
                int like = snapshot.data![index]["data"]["like"] ?? 0;
                int dislike = snapshot.data![index]["data"]["dislike"] ?? 0;
                int up = like;
                int down = dislike;
                String userId = snapshot.data![index]["data"]["userId"];
                String profesion = snapshot.data![index]["data"]["profesion"];
                String experiencia =
                    snapshot.data![index]["data"]["experiencia"];
                String descripcion =
                    snapshot.data![index]["data"]["descripcion"];
                String cell = snapshot.data![index]["data"]["cell"];
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          textAlign: TextAlign.center,
                          "Profesion: $profesion",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "Experiencia: $experiencia años",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        Text(
                          "Descripción: $descripcion, contacto: $cell",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),

                        Row(
                          children: [
                            Spacer(),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isLiked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    Like.createLike(userId);
                                    setState(() {
                                      isLiked =
                                          !isLiked; // recarga datos actualizados
                                    });
                                  },
                                ),
                                SizedBox(height: 4),
                                Text(
                                  up.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 18),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isDislike
                                        ? Icons.thumb_down
                                        : Icons.thumb_down_alt_outlined,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    Like.dislike(userId);
                                    setState(() {
                                      isDislike = !isDislike;
                                    });
                                  },
                                ),
                                SizedBox(height: 4),
                                Text(
                                  down.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
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
