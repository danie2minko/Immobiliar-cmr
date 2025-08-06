import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  final String? id;
  final String? imageUrl;
  final String type;
  final double prix;
  final String ville;
  final String quartier;
  final String description;
  final String? ownerId; 
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final DateTime? createdAt;

  Products({
    this.id,
    this.imageUrl,
    required this.type,
    required this.description,
    required this.prix,
    required this.ville,
    required this.quartier,
    this.ownerId, 
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.createdAt,
  });
  // Créer un Products à partir d'un Map (pour Firestore)
  factory Products.fromMap(Map<String, dynamic> map, String id) {
    final imageUrl = map['imageUrl'];
    print('🔍 Products.fromMap - ID: $id, ImageURL: $imageUrl');

    return Products(
      id: id,
      imageUrl: imageUrl,
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      prix: (map['prix'] ?? 0).toDouble(),
      ville: map['ville'] ?? '',
      quartier: map['quartier'] ?? '',
      ownerId: map['ownerId'], 
      ownerName: map['ownerName'],
      ownerPhone: map['ownerPhone'],
      ownerEmail: map['ownerEmail'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
