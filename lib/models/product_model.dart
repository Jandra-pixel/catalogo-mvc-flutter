// MODELO (Model):
// Define la estructura de datos del producto. Incluye ID, Título, Precio,
// Imagen, Descripción y Categoría para soportar el catálogo y el detalle[cite: 1].

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  final String description; // Atributo para la US05
  final String category;    // Atributo para la US05

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  // Convierte la respuesta JSON de la FakeStoreAPI en un objeto manejable por Dart[cite: 1]
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      description: json['description'] ?? 'Sin descripción disponible.',
      category: json['category'] ?? 'General',
    );
  }
}