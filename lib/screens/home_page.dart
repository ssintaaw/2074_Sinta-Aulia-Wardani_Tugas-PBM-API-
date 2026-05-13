import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productsFuture = _apiService.getProducts();
    });
  }

  void _deleteProduct(int? id, int index, List<Product> currentList) async {
    if (id == null) {
      setState(() {
        currentList.removeAt(index);
      });
      return;
    }

    try {
      bool success = await _apiService.deleteProduct(id);
      if (success) {
        _refreshProducts();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil dihapus")),
          );
        }
      }
    } catch (e) {
      setState(() {
        currentList.removeAt(index);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dihapus dari tampilan lokal")),
        );
      }
    }
  }

  void _logout() async {
    await _apiService.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7EEF2),
      appBar: AppBar(
        title: const Text(
          "PrelovedArea",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: const Color(0xFF6E2137),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6E2137)));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off_rounded, size: 60, color: Color(0xFF6E2137)),
                    const SizedBox(height: 16),
                    Text("Oops! Terjadi kesalahan: ${snapshot.error}", textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _refreshProducts,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6E2137), foregroundColor: Colors.white),
                    )
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: const Color(0xFF6E2137).withOpacity(0.3)),
                  const SizedBox(height: 16),
                  const Text("Belum ada produk preloved.", style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }

          final products = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshProducts,
            color: const Color(0xFF6E2137),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Section Title
                const Padding(
                  padding: EdgeInsets.only(bottom: 16, left: 4),
                  child: Row(
                    children: [
                      Icon(Icons.stars_rounded, color: Color(0xFF6E2137), size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Barang Preloved Terbaru",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6E2137),
                        ),
                      ),
                    ],
                  ),
                ),
                // Products List
                ...products.asMap().entries.map((entry) {
                  int idx = entry.key;
                  Product product = entry.value;
                  return ProductCard(
                    product: product,
                    onDelete: () => _deleteProduct(product.id, idx, products),
                  );
                }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "submit",
            onPressed: () => Navigator.pushNamed(context, '/submit'),
            backgroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            icon: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF6E2137), size: 20),
            label: const Text(
              "Submit",
              style: TextStyle(color: Color(0xFF6E2137), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: "add",
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/add');
              if (result == true) {
                await _refreshProducts();
              }
            },
            backgroundColor: const Color(0xFF6E2137),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text("Jual Barang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
