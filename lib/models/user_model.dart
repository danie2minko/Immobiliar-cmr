class UserModel {
  final String uid;
  final String email;
  final String username;
  final String phone;
  final String city;
  final String bio;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.phone = '',
    this.city = '',
    this.bio = '',
    this.createdAt,
  }); // Créer un UserModel à partir d'un Map
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    DateTime? createdAt;
    if (map['createdAt'] != null) {
      try {
        // Essayer d'abord si c'est déjà un DateTime
        if (map['createdAt'] is DateTime) {
          createdAt = map['createdAt'];
        } else {
          // Sinon, essayer de convertir depuis Timestamp
          createdAt = map['createdAt'].toDate();
        }
      } catch (e) {
        print('Erreur lors de la conversion de la date: $e');
        createdAt = null;
      }
    }

    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      username: map['username'] ?? 'Utilisateur',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      bio: map['bio'] ?? '',
      createdAt: createdAt,
    );
  }

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phone': phone,
      'city': city,
      'bio': bio,
      'uid': uid,
    };
  }

  // Créer une copie avec des modifications
  UserModel copyWith({
    String? email,
    String? username,
    String? phone,
    String? city,
    String? bio,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      bio: bio ?? this.bio,
      createdAt: createdAt,
    );
  }
}
