// CONTROLADOR (Controller):
// Maneja todas las peticiones HTTP HTTP GET hacia la FakeStoreAPI[cite: 1, 2].

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductController {
  
  // US03: Obtiene el catálogo completo (/products)[cite: 1]
  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los productos');
    }
  }

  // US04: Obtiene la lista de categorías disponibles (/products/categories)[cite: 2]
  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item.toString()).toList();
    } else {
      throw Exception('Error al cargar las categorías');
    }
  }

  // US04: Obtiene productos filtrados por categoría (/products/category/{category})[cite: 2]
  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/category/$category'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los productos filtrados');
    }
  }

  // US05: Obtiene el detalle de un solo producto por su ID (/products/{id})
  Future<ProductModel> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Producto no disponible');
    }
  }
}