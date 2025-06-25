import 'package:flutter/material.dart';
import 'package:immobiliakamer/components/mydrawer.dart';
import 'package:immobiliakamer/components/myproducttile.dart';
import 'package:immobiliakamer/models/products.dart';
import 'package:immobiliakamer/services/product_service.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  final ProductService _productService = ProductService();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Accueil",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const Mydrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          // Barre de recherche iOS style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icône historique des recherches
                      GestureDetector(
                        onTap: () {
                          // TODO: Implémenter l'historique des recherches
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Historique des recherches'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.history_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 18,
                          ),
                        ),
                      ),
                      // Icône micro pour recherche vocale
                      GestureDetector(
                        onTap: () {
                          // TODO: Implémenter la recherche vocale
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Recherche vocale en développement'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.mic_rounded,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Liste des produits
          SizedBox(
            height: 550,
            child: StreamBuilder<List<Products>>(
              stream: _productService.getProductsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erreur: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_outlined,
                            size: 100, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Aucun bien immobilier disponible',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text('Soyez le premier à publier un bien !',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                List<Products> filteredProducts = snapshot.data!;

                // Filtrer selon la recherche
                if (_searchQuery.isNotEmpty) {
                  filteredProducts = filteredProducts.where((product) {
                    return product.type.toLowerCase().contains(_searchQuery) ||
                        product.ville.toLowerCase().contains(_searchQuery) ||
                        product.quartier.toLowerCase().contains(_searchQuery) ||
                        product.description
                            .toLowerCase()
                            .contains(_searchQuery);
                  }).toList();
                }

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Text('Aucun résultat trouvé pour "$_searchQuery"',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  );
                }

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Myproducttile(products: product, width: 300);
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/ia');
        },
        child: Icon(Icons.smart_toy),
        backgroundColor: Colors.blue,
        elevation: 6,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
