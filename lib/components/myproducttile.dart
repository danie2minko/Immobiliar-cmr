import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:immobiliakamer/models/products.dart';

class Myproducttile extends StatelessWidget {
  final Products products;
  final double? width; // Largeur optionnelle
  const Myproducttile({super.key, required this.products, this.width});
  @override
  Widget build(BuildContext context) {
    // Debug: afficher l'URL de l'image dans la console
    final isValidImageUrl = products.imageUrl != null &&
        products.imageUrl!.isNotEmpty &&
        (products.imageUrl!.startsWith('http://') ||
            products.imageUrl!.startsWith('https://'));
    print(
        '[Myproducttile] ${products.type} | imageUrl: ${products.imageUrl} | isValid: $isValidImageUrl');
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 0,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section avec overlay de prix
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.3,
                    child: (products.imageUrl != null &&
                            products.imageUrl!.isNotEmpty &&
                            (products.imageUrl!.startsWith('http://') ||
                                products.imageUrl!.startsWith('https://')))
                        ? Image.network(
                            products.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.home_outlined,
                                        size: 48,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant
                                            .withOpacity(0.6),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Image non disponible',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.home_outlined,
                                    size: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.6),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pas d\'image',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  // Prix en overlay
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${products.prix.toStringAsFixed(0)}FCFA',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Contenu de la carte
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type de propriété
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        products.type,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Localisation
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${products.quartier}, ${products.ville}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

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
                    const SizedBox(height: 10), // Boutons d'action
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        children: [
                          // Bouton de contact
                          Expanded(
                            child: ElevatedButton.icon(
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
                              icon: const Icon(CupertinoIcons.chat_bubble_2,
                                  size: 18, color: Colors.white),
                              label: const Text('Contacter',
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
                          ),
                          const SizedBox(width: 12),

                          
                          // Bouton pour l'analyse IA
                          Expanded(
                            child: OutlinedButton.icon(
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
                              label: const Text('Analyser'),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
