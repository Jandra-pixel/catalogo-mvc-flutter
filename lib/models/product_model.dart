// MODELO (Model):
// Define la estructura de datos del producto. Incluye ID, Título, Precio,
// Imagen, Descripción y Categoría para soportar el catálogo y el detalle.

// Plantilla o ficha que representa a un solo producto
class ProductModel {
  final int id;            // Número identificador único del producto
  final String title;      // Nombre o título del producto
  final double price;      // Precio del producto (con decimales)
  final String image;      // Enlace de internet a la foto del producto
  final String description; // Texto largo que describe el producto
  final String category;    // Tipo o categoría a la que pertenece (ej: ropa, electrónica)

  // Constructor: Se encarga de pedir obligatoriamente todos los datos para armar la ficha del producto
  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
  });

  // Función especial que convierte los datos que vienen de internet (JSON) en un objeto que la app entiende
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'], // Asigna el número de ID
      title: json['title'] ?? '', // Toma el título, o deja un texto vacío si no viene nada
      price: (json['price'] as num).toDouble(), // Convierte el precio a un número con decimales
      image: json['image'] ?? '', // Toma la foto, o deja texto vacío si falta
      description: json['description'] ?? 'Sin descripción disponible.', // Si no hay descripción, pone este mensaje por defecto
      category: json['category'] ?? 'General', // Si no especifica categoría, asigna 'General'
    );
  }
}
