import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/product_service.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Publish extends StatefulWidget {
  const Publish({super.key});

  @override
  State<Publish> createState() => _PublishState();
}

class _PublishState extends State<Publish> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  final _formKey = GlobalKey<FormState>();
final FirebaseAuth _auth = FirebaseAuth.instance;
User? get currentUser => _auth.currentUser;
// Services et contrôleurs pour le backend
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

// Contrôleurs pour les champs
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _quartierController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getUserData();
    if (userData != null) {
      setState(() {
        _ownerNameController.text = userData['username'] ?? '';
        _ownerPhoneController.text = userData['phone'] ?? '';
        _ownerEmailController.text = userData['email'] ?? '';
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la sélection de l'image: $e")),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final productId = await _productService.addProduct(
        type: _typeController.text.trim(),
        description: _descriptionController.text.trim(),
        prix: double.parse(_prixController.text.trim()),
        ville: _villeController.text.trim(),
        quartier: _quartierController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        ownerEmail: _ownerEmailController.text.trim(),
        imageFile: _selectedImage,
        ownerId: currentUser?.uid,
      );

      if (productId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Produit ajouté avec succès !")),
        );

        // Réinitialiser le formulaire
        _formKey.currentState!.reset();
        setState(() {
          _typeController.clear();
          _prixController.clear();
          _villeController.clear();
          _quartierController.clear();
          _descriptionController.clear();
          _selectedImage = null;
        });
        // Retourner à l'écran principal avec la navbar
        Navigator.pushReplacementNamed(context, '/homescreen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'ajout du produit")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          // ...existing code...

          // draggable sheet
          DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.9,

            snap: true,
            snapSizes: const [0.3, 0.9], // S'arrête à 30% et 90%

            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // Le contenu du sheet
                child: Column(
                  children: [
                    // La "poignée" pour indiquer que le sheet est draggable
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    // Le reste du contenu doit être dans un Expanded pour que le scroll fonctionne
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          children: [
                            Text(
                              'Property Details',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            //SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _typeController,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Type de bien',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer le type de bien';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            //const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _prixController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Prix',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer le prix';
                                      }
                                      if (double.tryParse(value) == null) {
                                        return 'Veuillez entrer un prix valide';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            //const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _villeController,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Ville',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer la ville';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            //const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _quartierController,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Quartier',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer le quartier';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Description',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer une description';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Widget pour l'upload d'image
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(15)),
                                child: _selectedImage != null
                                    ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Image.file(
                                              _selectedImage!,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedImage = null;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : GestureDetector(
                                        onTap: _pickImage,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Ajouter une photo du bien',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  'Choisir une image',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Owner Details',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            //SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _ownerNameController,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Nom du propriétaire',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer le nom du propriétaire';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _ownerPhoneController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Téléphone',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer le numéro de téléphone';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextFormField(
                                    controller: _ownerEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      hintText: 'Email',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Veuillez entrer l\'email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Veuillez entrer un email valide';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _isLoading ? null : _submitForm,
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Soumettre',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                            const SizedBox(
                                height: 20), // Espace en bas pour le scroll
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
