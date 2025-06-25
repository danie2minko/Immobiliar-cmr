import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';

// Import des pages
import 'auth/main_page.dart';
import 'pages/homescreen.dart';
import 'pages/acceuil.dart';
import 'pages/profil.dart';
import 'pages/ia.dart';
import 'pages/messages.dart';
import 'pages/acheter.dart';
import 'pages/partage.dart';

// Import des modèles et thèmes
import 'models/shop.dart';
import 'models/products.dart'; // Importation du modèle Products
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
          "AIzaSyC3cdxJrrEZ15dhj6TeU9hbEh2stAXeI2E"); //TODO: Add your Gemini API key here

  // Lancement de l'application
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

        // Page d'accueil - MainPage gère l'authentification
        home: const MainPage(), // Définition des routes nommées
        routes: {
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
