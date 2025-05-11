import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  static const Duration _timeout = Duration(seconds: 10);

  static Future<bool> testConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products/1'))
          .timeout(_timeout);
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('API Connection Error: $e');
      return false;
    }
  }

  // Get all products
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Get Products Error: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  // Get product by id
  static Future<Product> getProduct(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/products/$id'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      print('Get Product Error: $e');
      throw Exception('Failed to load product: $e');
    }
  }

  // Get products by category
  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/categories/$categoryId/products'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load products by category: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Get Products By Category Error: $e');
      throw Exception('Failed to load products by category: $e');
    }
  }
}
