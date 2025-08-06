// Fichier : components/small_product.dart (Version simplifiée et fonctionnelle)

import 'package:flutter/material.dart';
import 'package:immobiliakamer/models/products.dart';

class SmallProduct extends StatelessWidget {
  final Products products;
  const SmallProduct({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final isValidImageUrl = products.imageUrl != null &&
        products.imageUrl!.isNotEmpty &&
        (products.imageUrl!.startsWith('http://') ||
            products.imageUrl!.startsWith('https://'));

    // Le widget parent est un Container qui va remplir l'espace donné par la GridView
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image ou Placeholder
                  isValidImageUrl
                      ? Image.network(
                          products.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(context),
                        )
                      : _buildPlaceholder(context),
                  
                  // Prix
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${products.prix.toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Informations textuelles
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products.type,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${products.quartier}, ${products.ville}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                   // Description
                    Text(
                      products.description,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                              onPressed: () {
                                if (products.ownerId != null &&
                                    products.ownerId!.isNotEmpty) {
                                  Navigator.pushNamed(
                                    context,
                                    '/messages',
                                    arguments: products,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Impossible de contacter cet utilisateur.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              icon: Center(
                                child: const Icon(Icons.chat_bubble_outline,
                                    size: 18, color: Colors.white),
                              ),
                              label: const Text('',
                                  style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                      SizedBox(width: 15,),
                      
                            OutlinedButton.icon(
                              onPressed: () {
                                // Naviguer vers l'écran de l'IA en passant le produit
                                Navigator.pushNamed(
                                  context,
                                  '/ia',
                                  arguments:
                                      products, // On passe l'objet produit entier
                                );
                              },
                              icon: const Icon(Icons.auto_awesome_outlined,
                                  size: 18),
                              label: const Text(''),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper pour ne pas répéter le code du placeholder
  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.home_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
      ),
    );
  }
}