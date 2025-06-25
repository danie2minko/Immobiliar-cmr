import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:immobiliakamer/pages/acceuil.dart';
import 'package:immobiliakamer/pages/acheter.dart';
import 'package:immobiliakamer/pages/partage.dart';
import 'package:immobiliakamer/pages/messages.dart';

class Homescreen extends StatefulWidget {
  final int initialIndex;
  const Homescreen({super.key, this.initialIndex = 0});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> screens = [
    const Acceuil(),
    const Acheter(),
    const Publish(),
    const Messages(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],

      //navigation bar

      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: _navigateBottomBar,
            gap: 8,
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade700,
            padding: const EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.shopping_cart_rounded,
                text: "Cart",
              ),
              GButton(
                icon: Icons.upload,
                text: "Share",
              ),
              GButton(
                icon: Icons.message_rounded,
                text: "Messages",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
