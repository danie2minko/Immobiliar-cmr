import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:immobiliakamer/themes/theme_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immobiliakamer/components/mylisttile.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: BeveledRectangleBorder(borderRadius: BorderRadiusGeometry.zero),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: Image.asset('assets/images/Immobilia1.png',
                width: 200, height: 200),
          ),
          SizedBox(
            height: 25,
          ), //listestyle
          Mylisttile(
              text: "P R O F I L",
              icon: Iconsax.profile_circle,
              onTap: () => Navigator.pushNamed(context, '/profile')),

          Mylisttile(
              text: "L A N G U E", icon: Iconsax.language_circle, onTap: () {}),

          Mylisttile(
            text: "T H E M E  ",
            icon: Icons.contrast,
            onTap: () {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
              Navigator.pop(context); // Ferme le drawer
            },
          ),

          Mylisttile(
              text: "P A R A M E T R E S", icon: Iconsax.setting, onTap: () {}),

          Mylisttile(
              text: "A P R O P O S", icon: Iconsax.info_circle, onTap: () {}),
          SizedBox(
            height: 40,
          ),

          Mylisttile(
              text: "D E C O N N E C T I O N",
              icon: Iconsax.logout,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/premiere', (route) => false))
        ],
      ),
    );
  }
}
