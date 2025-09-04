import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immobiliakamer/components/mylisttile.dart';

class Apropos extends StatefulWidget {
  const Apropos({super.key});

  @override
  State<Apropos> createState() => _AproposState();
}

class _AproposState extends State<Apropos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A propos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text("A propos de votre compte"),
              leading: Icon(Iconsax.warning_2),
            ),
            ListTile(
              title: Text("Mise a jour de l'application"),
              leading: Icon(Iconsax.recovery_convert),
            ),
            ListTile(
              title: Text("Conditions d'utilisation"),
              leading: Icon(Iconsax.lamp),
            ),
            ListTile(
              title: Text("Politique de securite"),
              leading: Icon(Iconsax.document),
            ),
            ListTile(
              title: Text("Bibliotheques Open Source"),
              leading: Icon(Iconsax.keyboard_open),
            )
          ],
        ),
      ),
    );
  }
}