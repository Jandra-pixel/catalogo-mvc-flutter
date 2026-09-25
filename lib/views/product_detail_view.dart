// VISTA DETALLADA DEL PRODUCTO
// Muestra la información del producto y condiciona la visualización
// de acciones administrativas según el Rol del usuario en sesión.

// Herramientas de diseño de Flutter
import 'package:flutter/material.dart';
// Trae la lógica que se encarga de pedir la información del producto
import '../controllers/product_controller.dart';
// Trae la plantilla con los datos del producto (nombre, precio, imagen, etc.)
import '../models/product_model.dart';

// Pantalla dinámica que puede cambiar lo que muestra según los datos que vayan llegando
class ProductDetailView extends StatefulWidget {
  final int productId; // El número identificador único del producto
  final String role; // El tipo de usuario (ejemplo: 'admin' o 'cliente')

  const ProductDetailView({
    super.key,
    required this.productId,
    required this.role,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  // Crea el controlador que gestiona los productos
  final _productController = ProductController();
  // Variable que guardará la promesa de los datos del producto mientras se descargan de internet
  late Future<ProductModel> _futureDetail;

  @override
  void initState() {
    super.initState();
    // Inicia la descarga de la información completa del producto usando su ID
    _futureDetail = _productController.fetchProductDetail(widget.productId);
  }

  // Muestra un mensaje rojo de error en pantalla y regresa a la pantalla anterior
  void _mostrarErrorYSalir() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto no disponible'),
          backgroundColor: Colors.redAccent,
        ),
      );
      Navigator.pop(context); // Cierra esta pantalla y regresa a la anterior
    });
  }

  @override
  Widget build(BuildContext context) {
    // Comprueba si el usuario es administrador (acepta 'administrador' o 'admin')
    final esAdmin = widget.role.toLowerCase() == 'administrador' || 
                    widget.role.toLowerCase() == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'), // Título en la barra superior
      ),
      // Construye la pantalla dependiendo de si los datos siguen cargando, fallaron o ya llegaron
      body: FutureBuilder<ProductModel>(
        future: _futureDetail,
        builder: (context, snapshot) {
          // Si los datos todavía se están cargando, muestra un círculo girando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB)));
          }

          // Si ocurrió un error al traer la información, muestra el aviso y sale
          if (snapshot.hasError) {
            _mostrarErrorYSalir();
            return const SizedBox.shrink(); // Espacio vacío mientras sale de la pantalla
          }

          // Extrae los datos del producto una vez descargados
          final product = snapshot.data!;

          // Permite desplazarse hacia abajo si el contenido no cabe en la pantalla
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0), // Margen alrededor de la pantalla
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinea todo a la izquierda
              children: [
                // Recuadro blanco donde se muestra la foto del producto
                Container(
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), // Esquinas redondeadas
                  ),
                  child: Image.network(
                    product.image, // Carga la imagen desde internet
                    fit: BoxFit.contain, // Ajusta la imagen sin deformarla
                    // Si la foto no carga o se rompe el enlace, muestra una imagen rota
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20), // Espacio transparente hacia abajo

                // Etiqueta morada con la categoría del producto en mayúsculas
                Chip(
                  label: Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color(0xFF9C27B0),
                ),
                const SizedBox(height: 12),

                // Título o nombre del producto
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),

                // Precio formato con 2 decimales y texto en color lila brillante
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE040FB),
                  ),
                ),
                const SizedBox(height: 16),

                // Título de la sección de descripción
                const Text(
                  'Descripción:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE1BEE7)),
                ),
                const SizedBox(height: 6),
                // Texto largo con la descripción detallada
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 24),

                // Muestra la sección de botones SOLO si el usuario es administrador
                if (esAdmin) ...[
                  const Divider(color: Colors.white24), // Línea separadora tenue
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Botón morado para Editar
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Muestra una barra avisando la acción
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Acción: Editar producto')),
                            );
                          },
                          icon: const Icon(Icons.edit), // Icono de lápiz
                          label: const Text('Editar'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Botón rojo para Eliminar
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Muestra una barra avisando la acción
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Acción: Eliminar producto')),
                            );
                          },
                          icon: const Icon(Icons.delete), // Icono de basurero
                          label: const Text('Eliminar'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
