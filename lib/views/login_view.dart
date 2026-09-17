// VISTA PRINCIPAL (login_view.dart)
// Incluye la pantalla de Login (US01), la pantalla del Catálogo con Filtros (US03, US04)
// y el Cierre de Sesión seguro destruyendo la pila de navegación (US02).

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import 'product_detail_view.dart';

// ==========================================
// PANTALLA 1: FORMULARIO DE LOGIN (US01)
// ==========================================
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controladores para capturar el texto ingresado por el usuario
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Instancia del controlador de autenticación
  final _authController = AuthController();

  bool _cargando = false;
  String? _errorMessage;

  // Método para procesar el inicio de sesión
  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Validar campos vacíos
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor ingresa usuario y contraseña';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _errorMessage = null;
    });

    // Crear modelo de usuario y llamar al servicio de autenticación
    final user = UserModel(username: username, password: password);
    final result = await _authController.login(user);

    if (!mounted) return;

    setState(() {
      _cargando = false;
    });

    // Si el login es exitoso, redirige al catálogo pasando datos del usuario
    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(
            username: username,
            role: result['role'],
            userId: result['userId'],
          ),
        ),
      );
    } else {
      // Muestra mensaje de error devuelto por la API
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x339C27B0),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícono decorativo en lila neón
                const Icon(Icons.lock_person, size: 80, color: Color(0xFFE040FB)),
                const SizedBox(height: 24),
                
                // Campo Usuario
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo Contraseña
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Mensaje de error visual si falla el login
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                // Botón de Envío
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: _cargando
                      ? const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB)))
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text('INGRESAR', style: TextStyle(fontSize: 16)),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// PANTALLA 2: CATÁLOGO Y FILTROS POR CATEGORÍA (US03, US04, US02)
// ==========================================================
class HomeView extends StatefulWidget {
  final String username;
  final String role;
  final int userId;

  const HomeView({
    super.key,
    required this.username,
    required this.role,
    required this.userId,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _productController = ProductController();
  late Future<List<ProductModel>> _futureProducts;
  late Future<List<String>> _futureCategories;

  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    // Carga inicial de categorías y productos desde la FakeStoreAPI
    _futureCategories = _productController.fetchCategories();
    _cargarProductos();
  }

  // Método para cargar productos (filtrados o globales)
  void _cargarProductos() {
    setState(() {
      if (_categoriaSeleccionada == null) {
        _futureProducts = _productController.fetchProducts();
      } else {
        _futureProducts = _productController.fetchProductsByCategory(_categoriaSeleccionada!);
      }
    });
  }

  // US04: Método para aplicar o remover filtro al tocar una categoría
  void _filtrarPorCategoria(String? categoria) {
    if (_categoriaSeleccionada == categoria) {
      _categoriaSeleccionada = null; // Remueve el filtro si vuelve a tocarlo
    } else {
      _categoriaSeleccionada = categoria;
    }
    _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo (${widget.role})'),
        actions: [
          // US02: Botón de Cierre de Sesión seguro
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFE040FB)),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              // 1. Limpia las credenciales almacenadas localmente
              await authController.logout();
              
              if (context.mounted) {
                // 2. Destruye la pila de navegación para impedir regresar con el botón "Atrás"
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // US04: Barra horizontal desplazable para filtrar por categorías
          FutureBuilder<List<String>>(
            future: _futureCategories,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final categorias = snapshot.data ?? [];
                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      // Chip para resetear filtros (Todos)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('Todos'),
                          selected: _categoriaSeleccionada == null,
                          onSelected: (_) => _filtrarPorCategoria(null),
                        ),
                      ),
                      // Chips dinámicos provenientes de la API
                      ...categorias.map((cat) {
                        final estaSeleccionada = _categoriaSeleccionada == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(cat.toUpperCase()),
                            selected: estaSeleccionada,
                            onSelected: (_) => _filtrarPorCategoria(cat),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // US03: Cuadrícula con el listado de productos
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                // Estado de Carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB)));
                }

                // Manejo de Error de Red con opción de Reintentar
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 60, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        const Text('Error al cargar productos desde el servidor'),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _cargarProductos,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final products = snapshot.data ?? [];

                if (products.isEmpty) {
                  return const Center(child: Text('No hay productos disponibles.'));
                }

                // GridView de 2 columnas
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Navega al detalle del producto enviando el ID y el Rol
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailView(
                              productId: product.id,
                              role: widget.role,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Contenedor blanco para la imagen del producto
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Título del producto
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Precio formateado en lila
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFFE040FB),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}