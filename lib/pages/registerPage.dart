import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class Registerpage extends StatefulWidget {
  final VoidCallback showLogin;
  const Registerpage({super.key, required this.showLogin});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  Future<void> signUp() async {
    if (_confirmPasswordController.text.trim() !=
        _passwordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Veuillez remplir tous les champs obligatoires")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _cityController.text.trim(),
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Compte créé avec succès !")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Échec de l'inscription")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // Logo avec effet
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.phone_android_rounded,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 32),

                // Titre
                Text(
                  "Créer un compte",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Rejoignez notre communauté",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 32),

                // Champ Nom d'utilisateur
                _buildTextField(
                  controller: _usernameController,
                  hintText: 'Nom d\'utilisateur',
                  icon: Icons.person_outline,
                  context: context,
                ),

                const SizedBox(height: 16),

                // Champ Email
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Adresse email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  context: context,
                ),

                const SizedBox(height: 16),

                // Champ Mot de passe
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Mot de passe',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  context: context,
                ),

                const SizedBox(height: 16),

                // Champ Confirmer mot de passe
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirmer le mot de passe',
                  icon: Icons.lock_outline,
                  obscureText: true,
                  context: context,
                ),

                const SizedBox(height: 16),

                // Champ Téléphone
                _buildTextField(
                  controller: _phoneController,
                  hintText: 'Numéro de téléphone',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  context: context,
                ),

                const SizedBox(height: 16),

                // Champ Ville
                _buildTextField(
                  controller: _cityController,
                  hintText: 'Ville',
                  icon: Icons.location_city_outlined,
                  context: context,
                ),

                const SizedBox(height: 32),

                // Bouton d'inscription
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      disabledBackgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'S\'inscrire',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Lien de connexion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Déjà un compte ? ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showLogin,
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required BuildContext context,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }
}
