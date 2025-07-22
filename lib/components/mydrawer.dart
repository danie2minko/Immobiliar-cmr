import 'package:flutter/material.dart';
import 'package:immobiliakamer/components/mylisttile.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // drawerheader
          DrawerHeader(
              child: Center(
            child: Image.asset('assets/images/Immobilia1.png', width: 300, height: 300),
          )),
          SizedBox(
            height: 25,
          ), //listestyle
          Mylisttile(
              text: "P R O F I L",
              icon: Icons.person,
              onTap: () => Navigator.pushNamed(context, '/profile')),

          Mylisttile(text: "L A N G U E", icon: Icons.language, onTap: () {}),

          Mylisttile(text: "T H E M E  ", icon: Icons.contrast, onTap: () {}),

          Mylisttile(
              text: "P A R A M E T R E S", icon: Icons.settings, onTap: () {}),

          Mylisttile(text: "A P R O P O S", icon: Icons.info, onTap: () {}),
          SizedBox(
            height: 40,
          ),

          Mylisttile(
              text: "D E C O N N E C T I O N",
              icon: Icons.logout,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/premiere', (route) => false))
        ],
      ),
    );
  }
}
