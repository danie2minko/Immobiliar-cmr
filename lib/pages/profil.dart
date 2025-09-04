import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  bool _isLoading = true;

  // Pour la photo de profil
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userData = await _authService.getUserData();
      if (userData != null && _authService.currentUser != null) {
        setState(() {
          _currentUser =
              UserModel.fromMap(userData, _authService.currentUser!.uid);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Photo de profil mise à jour ! ")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sélection de l'image: $e")),
      );
    }
  }

  Future<void> _signOut() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _authService.signOut();
                // Rediriger explicitement vers la page de connexion
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                }
              },
              child: Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text("Profil"),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? Center(child: Text('Erreur lors du chargement du profil'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Photo et informations de base
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(75),
                                      image: _profileImage != null
                                          ? DecorationImage(
                                              image: FileImage(_profileImage!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: _profileImage == null
                                        ? Icon(
                                            Iconsax.profile_circle,
                                            size: 100,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentUser!.username.isNotEmpty
                                      ? _currentUser!.username
                                      : 'Nom d\'utilisateur',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  _currentUser!.phone.isNotEmpty
                                      ? _currentUser!.phone
                                      : 'Numéro de téléphone',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  _currentUser!.city.isNotEmpty
                                      ? _currentUser!.city
                                      : 'Ville',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Informations personnelles
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informations personnelles',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildInfoTile(
                                'Nom d\'utilisateur', _currentUser!.username),
                            SizedBox(height: 10),
                            _buildInfoTile('Email', _currentUser!.email),
                            SizedBox(height: 10),
                            _buildInfoTile(
                                'Téléphone',
                                _currentUser!.phone.isNotEmpty
                                    ? _currentUser!.phone
                                    : 'Non renseigné'),
                            SizedBox(height: 10),
                            _buildInfoTile('Mot de passe', '••••••••'),
                            SizedBox(height: 10),
                            _buildInfoTile(
                                'Ville',
                                _currentUser!.city.isNotEmpty
                                    ? _currentUser!.city
                                    : 'Non renseignée'),
                            SizedBox(height: 10),
                            _buildInfoTile(
                                'Biographie',
                                _currentUser!.bio.isNotEmpty
                                    ? _currentUser!.bio
                                    : 'Non renseignée'),
                            SizedBox(height: 20),

                            // Informations du compte
                            Text(
                              'Informations du compte',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildSimpleTile('Compte'),
                            SizedBox(height: 5),
                            _buildSimpleTile('Confidentialité'),
                            SizedBox(height: 5),
                            _buildSimpleTile('Aide'),
                          ],
                        ),
                      ),
                      SizedBox(height: 40),

                      // Bouton de déconnexion
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ElevatedButton(
                          onPressed: _signOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Text(
                              'Déconnexion',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      height: 50,
      width: 350,
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[900]
                                        : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(Iconsax.edit, color: Colors.grey.shade600, size: 20),
        ],
      ),
    );
  }

  Widget _buildSimpleTile(String text) {
    return Container(
      height: 50,
      width: 350,
      padding: const EdgeInsets.only(left: 10, top: 15, right: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[900]
                                        : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
