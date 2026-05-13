import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onDelete,
  });

  IconData getProductIcon(String name) {
    String lowerName = name.toLowerCase();
    
    if (lowerName.contains('masak') || lowerName.contains('dapur') || lowerName.contains('piring') || lowerName.contains('gelas')) {
      return Icons.soup_kitchen_rounded;
    } else if (lowerName.contains('belajar') || lowerName.contains('buku') || lowerName.contains('meja')) {
      return Icons.menu_book_rounded;
    } else if (lowerName.contains('kursi')) {
      return Icons.chair_alt_rounded;
    } else if (lowerName.contains('rak')) {
      return Icons.grid_view_rounded;
    } else if (lowerName.contains('baju') || lowerName.contains('celana') || lowerName.contains('pakaian')) {
      return Icons.checkroom_rounded;
    } else if (lowerName.contains('tas') || lowerName.contains('dompet')) {
      return Icons.shopping_bag_rounded;
    } else if (lowerName.contains('aksesoris') || lowerName.contains('perhiasan') || lowerName.contains('kalung')) {
      return Icons.diamond_rounded;
    } else if (lowerName.contains('elektronik') || lowerName.contains('hp') || lowerName.contains('laptop') || lowerName.contains('listrik')) {
      return Icons.electrical_services_rounded;
    }
    
    return Icons.inventory_2_rounded; // Default icon
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDFD), // Surface color
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6E2137).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFD7B6C2).withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [

            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF7EEF2), // Background accent
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                getProductIcon(product.name),
                size: 32,
                color: const Color(0xFF6E2137), // Primary Maroon
              ),
            ),
            const SizedBox(width: 16),
            // Middle: Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B2B2B), // Main Text
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Price Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6E2137), // Primary Maroon
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Rp ${product.price}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF2B2B2B).withOpacity(0.6),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Right: Delete Action
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_rounded,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
