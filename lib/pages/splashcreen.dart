import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      debugPrint('test ');
      Navigator.pushReplacementNamed(context, '/mainpage');
            debugPrint('test ');
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 180,),
            Image.asset('assets/images/Immobilia0.png',),
          ],
        ),
      ),
    );
  }
}