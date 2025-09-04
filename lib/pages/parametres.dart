import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parametres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[900]
                                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5),
                ),
                //child: Icon(Iconsax.search_normal),
              ),
            ),
        
            ListTile(
              title: Text("Espace compte"),
              leading: Icon(Iconsax.personalcard),
            ),
            Divider(
              height: 40,
              thickness: 3.0,
              radius: BorderRadius.circular(3),
            ),
            ListTile(
              title: Text("Archive"),
              leading: Icon(Iconsax.archive),
            ),ListTile(
              title: Text("Votre activite"),
              leading: Icon(Iconsax.activity),
            ),
            ListTile(
              title: Text("Bloque"),
              leading: Icon(Iconsax.stop_circle),
            ),
            ListTile(
              title: Text("Favoris"),
              leading: Icon(Iconsax.favorite_chart),
            ),
            Divider(
              height: 40,
              thickness: 3.0,
              radius: BorderRadius.circular(3),
            ),
            ListTile(
              title: Text("Autorisation de l'appareil"),
              leading: Icon(Iconsax.computing),
            ),
            ListTile(
              title: Text("Utilisation des donnees"),
              leading: Icon(Iconsax.data),
            ),
          ],
        ),
      ),
    );
  }
}