import 'package:flutter/material.dart';
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
          SnackBar(
              content: Text("Photo de profil mise à jour ! (stockage local)")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sélection de l'image: $e")),
      );
    }
  }

  Future<void> _updateField(String field, String value) async {
    if (value.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le champ ne peut pas être vide")),
      );
      return;
    }

    try {
      final updateData = {field: value.trim()};
      final success = await _authService.updateUserData(updateData);

      if (success) {
        // Si c'est le nom d'utilisateur, mettre à jour aussi Firebase Auth
        if (field == 'username') {
          await _authService.updateDisplayName(value.trim());
        }

        // Recharger les données
        await _loadUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "${_getFieldDisplayName(field)} mis à jour avec succès !")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la mise à jour")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  String _getFieldDisplayName(String field) {
    switch (field) {
      case 'username':
        return 'Nom d\'utilisateur';
      case 'phone':
        return 'Téléphone';
      case 'city':
        return 'Ville';
      case 'bio':
        return 'Biographie';
      case 'email':
        return 'Email';
      default:
        return field;
    }
  }

  void _showEditDialog(String label, String currentValue, String field) {
    final TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(),
            ),
            maxLines: field == 'bio' ? 3 : 1,
            keyboardType:
                field == 'phone' ? TextInputType.phone : TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.dispose();
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final newValue = controller.text.trim();
                controller.dispose();
                Navigator.of(context).pop();

                if (newValue != currentValue) {
                  await _updateField(field, newValue);
                }
              },
              child: Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
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
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius: BorderRadius.circular(75),
                                      image: _profileImage != null
                                          ? DecorationImage(
                                              image: FileImage(_profileImage!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: _profileImage == null
                                        ? Icon(Icons.person,
                                            size: 100,
                                            color: Colors.grey.shade700)
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
                            _buildEditableInfoTile('Nom d\'utilisateur',
                                _currentUser!.username, 'username'),
                            _buildEditableInfoTile(
                                'Email', _currentUser!.email, 'email'),
                            _buildEditableInfoTile(
                                'Téléphone', _currentUser!.phone, 'phone'),
                            _buildInfoTile('Mot de passe', '••••••••'),
                            _buildEditableInfoTile(
                                'Ville', _currentUser!.city, 'city'),
                            _buildEditableInfoTile(
                                'Biographie', _currentUser!.bio, 'bio'),
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
                            _buildSimpleTile('Confidentialité'),
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

  Widget _buildEditableInfoTile(String label, String value, String field) {
    // L'email ne doit pas être modifiable facilement
    bool isEditable = field != 'email';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Non renseigné',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: field == 'bio' ? 2 : 1,
                ),
              ],
            ),
          ),
          if (isEditable)
            IconButton(
              onPressed: () => _showEditDialog(label, value, field),
              icon: Icon(Icons.edit, color: Colors.grey.shade600, size: 20),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTile(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
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
