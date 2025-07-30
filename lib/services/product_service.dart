import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/products.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Ajout de FirebaseAuth

  // Ajouter un nouveau produit
  Future<String?> addProduct({
    required String type,
    required String description,
    required double prix,
    required String ville,
    required String quartier,
    required String ownerName,
    required String ownerPhone,
    required String ownerEmail,
    File? imageFile,
    File? cniImageFile,
    String? ownerId, // ID du propriétaire, optionnel
  }) async {
    try {
      // Récupérer l'utilisateur actuel
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('🔴 Aucun utilisateur n\'est connecté.');
        return null;
      }

      String? imageUrl;
      String? imageUrl1;

      // Upload de l'image si fournie
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile);
        if (imageUrl == null) {
          print(
              '🔴 L\'upload de l\'image a échoué. Le produit sera créé sans image.');
        } else {
          print('🟢 URL image uploadée: $imageUrl');
        }
      }

      if (cniImageFile != null) {
        imageUrl1 = await _uploadImage(cniImageFile);
        if (imageUrl1 == null) {
          print(
              '🔴 L\'upload de l\'image a échoué. Le produit sera créé sans image.');
        } else {
          print('🟢 URL image uploadée: $imageUrl1');
        }
      }

      // Créer le map de données pour Firestore
      final Map<String, dynamic> productData = {
        'type': type,
        'description': description,
        'prix': prix,

        'ville': ville,
        'quartier': quartier,
        'ownerId': currentUser.uid, // Ajout de l'ID du propriétaire
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'ownerEmail': ownerEmail,
        'imageUrl': imageUrl, // Peut être null
        'createdAt': FieldValue.serverTimestamp(), // Utilise l'heure du serveur
      };
      print('🟢 Produit à stocker: \n$productData');
      // Ajouter à Firestore
      DocumentReference docRef =
          await _firestore.collection('products').add(productData);

      return docRef.id;
    } catch (e) {
      print('Erreur lors de l\'ajout du produit: $e');
      return null;
    }
  }

  // Upload d'image vers Firebase Storage
  Future<String?> _uploadImage(File imageFile) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('products').child(fileName);

      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erreur lors de l\'upload de l\'image: $e');
      return null;
    }
  }

  // Récupérer tous les produits
  Future<List<Products>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              Products.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Erreur lors de la récupération des produits: $e');
      return [];
    }
  }

  // Stream pour écouter les changements en temps réel
  Stream<List<Products>> getProductsStream() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print(
          '📡 Récupération de ${snapshot.docs.length} produits depuis Firestore');
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final product = Products.fromMap(data, doc.id);
        print('🏠 Produit: ${product.type}, Image URL: ${product.imageUrl}');
        return product;
      }).toList();
    });
  }

  // Supprimer un produit
  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      return true;
    } catch (e) {
      print('Erreur lors de la suppression: $e');
      return false;
    }
  }
}
