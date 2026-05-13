import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://task.itprojects.web.id/api';
  final storage = const FlutterSecureStorage();

  // Save token
  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Delete token (logout)
  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  // Login
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Assuming the token is in data['token'] or data['data']['token']
      // Let's handle both common cases
      String token = '';
      if (data['token'] != null) {
        token = data['token'];
      } else if (data['data'] != null && data['data']['token'] != null) {
        token = data['data']['token'];
      }
      
      if (token.isNotEmpty) {
        await saveToken(token);

        debugPrint("TOKEN BERHASIL DISIMPAN:");
        debugPrint(token);
      }
      return data;
    } else {
      throw Exception('Gagal Login: ${response.body}');
    }
  }

    Future<List<Product>> getProducts() async {
     final token = await getToken();

     final response = await http.get(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

  if (response.statusCode == 200) {
    debugPrint("API Response: ${response.body}");

    final jsonResponse = jsonDecode(response.body);

    final List dataList = jsonResponse['data']['products'];

    return dataList
        .map((item) => Product.fromJson(item))
        .toList();
  } else {
    throw Exception('Gagal memuat produk');
  }
}

  // Add product
  Future<bool> addProduct(Product product) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': product.name,
        'price': int.tryParse(product.price.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        'description': product.description,
      }),
    );

    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  // Submit task
  Future<bool> submitTask(String name, String price, String description, String githubUrl) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/products/submit'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': int.tryParse(price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
