import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Stream pour écouter les changements d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obtenir les informations de l'utilisateur depuis Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (currentUser == null) return null;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        // Si le document n'existe pas, créer un avec les infos de base
        await createUserDocument();
        return {
          'email': currentUser!.email,
          'username': currentUser!.displayName ?? 'Utilisateur',
          'phone': '',
          'city': '',
          'bio': '',
          'createdAt': FieldValue.serverTimestamp(),
        };
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }

  // Créer un document utilisateur dans Firestore
  Future<void> createUserDocument() async {
    if (currentUser == null) return;

    final userData = {
      'email': currentUser!.email,
      'username': currentUser!.displayName ?? 'Utilisateur',
      'phone': '',
      'city': '',
      'bio': '',
      'uid': currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .set(userData, SetOptions(merge: true));
    } catch (e) {
      print('Erreur lors de la création du document utilisateur: $e');
    }
  }

  // Mettre à jour les informations de l'utilisateur
  Future<bool> updateUserData(Map<String, dynamic> data) async {
    if (currentUser == null) return false;

    try {
      await _firestore.collection('users').doc(currentUser!.uid).update(data);
      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour des données: $e');
      return false;
    }
  }

  // Mettre à jour le nom d'affichage
  Future<bool> updateDisplayName(String displayName) async {
    if (currentUser == null) return false;

    try {
      await currentUser!.updateDisplayName(displayName);
      await updateUserData({'username': displayName});
      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour du nom: $e');
      return false;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  // Connexion
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Créer ou mettre à jour le document utilisateur après connexion
      await createUserDocument();

      return result;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }

  // Inscription
  Future<UserCredential?> signUp(String email, String password, String username,
      {String? phone, String? city}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Mettre à jour le nom d'affichage
      await result.user!.updateDisplayName(username);

      // Créer le document utilisateur avec les informations supplémentaires
      final userData = {
        'email': email,
        'username': username,
        'phone': phone ?? '',
        'city': city ?? '',
        'bio': '',
        'uid': result.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(result.user!.uid).set(userData);

      return result;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      return null;
    }
  }
}
