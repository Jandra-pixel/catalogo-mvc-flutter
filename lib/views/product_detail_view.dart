// VISTA DETALLADA DEL PRODUCTO (product_detail_view.dart)
// Muestra la información técnica del producto (US05) y condiciona la visualización
// de acciones administrativas (Editar/Eliminar) según el Rol del usuario en sesión.

import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class ProductDetailView extends StatefulWidget {
  final int productId;
  final String role; // Rol recibido desde la sesión activa

  const ProductDetailView({
    super.key,
    required this.productId,
    required this.role,
  });

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final _productController = ProductController();
  late Future<ProductModel> _futureDetail;

  @override
  void initState() {
    super.initState();
    // Obtiene el detalle completo del producto por ID desde la FakeStoreAPI
    _futureDetail = _productController.fetchProductDetail(widget.productId);
  }

  // Notificación en caso de error al cargar el detalle
  void _mostrarErrorYSalir() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Producto no disponible'),
          backgroundColor: Colors.redAccent,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // US05: Evaluación local de permisos basada en el rol del usuario
    final esAdmin = widget.role.toLowerCase() == 'administrador' || 
                    widget.role.toLowerCase() == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'),
      ),
      body: FutureBuilder<ProductModel>(
        future: _futureDetail,
        builder: (context, snapshot) {
          // Indicador de Carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB)));
          }

          // Control de Excepciones o Errores de API
          if (snapshot.hasError) {
            _mostrarErrorYSalir();
            return const SizedBox.shrink();
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen ampliada del producto
                Container(
                  width: double.infinity,
                  height: 250,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 20),

                // Badge de Categoría
                Chip(
                  label: Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: const Color(0xFF9C27B0),
                ),
                const SizedBox(height: 12),

                // Título del Producto
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),

                // Precio en Lila Neón
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE040FB),
                  ),
                ),
                const SizedBox(height: 16),

                // Descripción Completa
                const Text(
                  'Descripción:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE1BEE7)),
                ),
                const SizedBox(height: 6),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
                ),
                const SizedBox(height: 24),

                // US05: Renderizado condicional de botones según el Rol
                if (esAdmin) ...[
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Botón Editar (Solo visible para Administradores)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Acción: Editar producto')),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Editar'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9C27B0)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Botón Eliminar (Solo visible para Administradores)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Acción: Eliminar producto')),
                            );
                          },
                          icon: const Icon(Icons.delete),
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