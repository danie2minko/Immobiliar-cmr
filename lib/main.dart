import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:immobiliakamer/pages/splashcreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';

import 'pages/splashcreen.dart';
import 'auth/main_page.dart';
import 'pages/homescreen.dart';
import 'pages/acceuil.dart';
import 'pages/profil.dart';
import 'pages/ia.dart';
import 'pages/messages.dart';
import 'pages/acheter.dart';
import 'pages/partage.dart';


import 'models/shop.dart';
import 'models/products.dart'; 
import 'themes/lightmode.dart';

void main() async {
  // Assurer l'initialisation des widgets Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(
      apiKey:
          "AIzaSyC3cdxJrrEZ15dhj6TeU9hbEh2stAXeI2E"); 

 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Shop(),
      child: MaterialApp(
        title: 'ImmobiliaKamer',
        debugShowCheckedModeBanner: false,
        theme: lightMode,

       
        home: SplashScreen(),
        routes: {
          '/mainpage': (context)=> const MainPage(),
          '/homescreen': (context) => const Homescreen(),
          '/acceuil': (context) => const Acceuil(),
          '/profile': (context) => const Profil(),
          '/messages': (context) => const Messages(),
          '/ia': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            final Products? product = args is Products ? args : null;
            return ChatScreen(product: product);
          },
          '/acheter': (context) => const Acheter(),
          '/partage': (context) => const Publish(),
        },
      ),
    );
  }
}
