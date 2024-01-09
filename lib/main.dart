import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Meteo(),
    );
  }
}

class Meteo extends StatefulWidget {
  const Meteo({super.key});

  @override
  State<Meteo> createState() => _MeteoState();
}

class _MeteoState extends State<Meteo> {
  List<String> ville = [];
  String villeChoisie = "";
  String key = "";

  @override
  void initState() {
    // TODO: implement initState
    obtenir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Coda Meteo"),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: ListView.builder(
              itemCount: (ville.length + 2),
              itemBuilder: (context, i) {
                if (i == 0) {
                  return DrawerHeader(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textAvecStylle('Mes villes', size: 22.0),
                      Card(
                        elevation: 12,
                        shadowColor: Colors.black,
                        shape: Border.all(
                          color: Colors.white,
                        ),
                        child: OutlinedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: Size(190, 40),
                          ),
                          onPressed: ajoutVille,
                          child: textAvecStylle("Ajouter une ville",
                              color: Colors.blue),
                        ),
                      )
                    ],
                  ));
                } else if (i == 1) {
                  return ListTile(
                    title: textAvecStylle("Ma ville actuelle"),
                  );
                }
                String vi = ville[i - 2];
                return ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        supprimer(vi);
                      },
                      icon: Icon(Icons.delete)),
                  title: textAvecStylle(vi),
                  onTap: () {
                    setState(() {
                      villeChoisie = vi;
                      Navigator.pop(context);
                    });
                  },
                );
              }),
        ),
      ),
      body: Center(child: textAvecStylle(villeChoisie, color: Colors.black)),
    );
  }

  Widget textAvecStylle(String text,
      {Color color = Colors.white,
      double size = 18,
      FontStyle fontStyle = FontStyle.italic}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontStyle: fontStyle,
      ),
    );
  }

  Future<void> ajoutVille() async {
    return showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(20),
          title:
              textAvecStylle("Ajouter une ville", size: 23, color: Colors.blue),
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "ville",
              ),
              onSubmitted: (String stri) {
                ajouter(stri);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void obtenir() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? liste = sharedPreferences.getStringList(key);
    if (liste != null) {
      setState(() {
        ville = liste;
      });
    }
  }

  void supprimer(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ville.remove(str);
    await sharedPreferences.setStringList(key, ville);
    obtenir();
  }

  void ajouter(String str) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ville.add(str);
    await sharedPreferences.setStringList(key, ville);
    obtenir();
  }
}
