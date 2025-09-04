import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immobiliakamer/components/mydrawer.dart';
import 'package:immobiliakamer/components/small_product.dart';
import 'package:immobiliakamer/models/products.dart';
import 'package:immobiliakamer/services/product_service.dart';

class Acheter extends StatefulWidget {
  const Acheter({super.key});

  @override
  State<Acheter> createState() => _AcheterState();
}

class _AcheterState extends State<Acheter> {
  final ProductService _productService = ProductService();
  String _searchQuery = '';
  String? _selectedCity;
  double? _maxPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text("Acheter"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      drawer: const Mydrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un bien...',
                hintStyle: TextStyle(color: Colors.grey.shade300),
                prefixIcon: Icon(
                  Iconsax.search_normal,
                  color: Colors.grey.shade300
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 2,
                    )),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey.shade200,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Filtres actifs
          if (_selectedCity != null || _maxPrice != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedCity != null)
                    Chip(
                      label: Text(_selectedCity!),
                      deleteIcon: Icon(Iconsax.close_circle),
                      onDeleted: () {
                        setState(() {
                          _selectedCity = null;
                        });
                      },
                    ),
                  if (_maxPrice != null)
                    Chip(
                      label: Text('Max: \$${_maxPrice!.toStringAsFixed(0)}'),
                      deleteIcon: Icon(Iconsax.close_circle),
                      onDeleted: () {
                        setState(() {
                          _maxPrice = null;
                        });
                      },
                    ),
                ],
              ),
            ),

          // Liste des produits
          Expanded(
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
                        Image.asset('assets/images/indisponible.png'),
                        SizedBox(height: 16),
                        Text('Aucun bien immobilier disponible',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text(
                            'Revenez plus tard pour découvrir de nouveaux biens !',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  );
                }

                List<Products> filteredProducts = snapshot.data!;

                // Appliquer les filtres
                filteredProducts = _applyFilters(filteredProducts);

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Aucun résultat trouvé',
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text('Essayez d\'ajuster vos critères de recherche',
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 3,
                      childAspectRatio: 0.7),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return
                        Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          SmallProduct(products: product // largeur responsive
                              ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Products> _applyFilters(List<Products> products) {
    List<Products> filtered = products;

    // Filtre par recherche textuelle
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.type.toLowerCase().contains(_searchQuery) ||
            product.ville.toLowerCase().contains(_searchQuery) ||
            product.quartier.toLowerCase().contains(_searchQuery) ||
            product.description.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Filtre par ville
    if (_selectedCity != null) {
      filtered = filtered
          .where((product) =>
              product.ville.toLowerCase() == _selectedCity!.toLowerCase())
          .toList();
    }

    // Filtre par prix maximum
    if (_maxPrice != null) {
      filtered =
          filtered.where((product) => product.prix <= _maxPrice!).toList();
    }

    return filtered;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtres'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    hintText: 'Entrez une ville',
                  ),
                  onChanged: (value) {
                    _selectedCity = value.isNotEmpty ? value : null;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Prix maximum',
                    hintText: 'Entrez un prix maximum',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _maxPrice = double.tryParse(value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCity = null;
                  _maxPrice = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Réinitialiser'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('Appliquer'),
            ),
          ],
        );
      },
    );
  }
}
