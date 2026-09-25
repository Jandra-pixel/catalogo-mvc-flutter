// VISTA PRINCIPAL (login_view.dart)
// Incluye la pantalla de Login (US01), la pantalla del Catálogo con Filtros (US03, US04)
// y el Cierre de Sesión seguro destruyendo la pila de navegación (US02).

// Importa los componentes visuales básicos de Flutter
import 'package:flutter/material.dart';
// Importa el controlador encargado del inicio y cierre de sesión
import '../controllers/auth_controller.dart';
// Importa el controlador encargado de traer los productos de internet
import '../controllers/product_controller.dart';
// Importa la estructura de datos del usuario
import '../models/user_model.dart';
// Importa la estructura de datos del producto
import '../models/product_model.dart';
// Importa la pantalla de detalle para poder navegar a ella al tocar un producto
import 'product_detail_view.dart';

// ==========================================
// PANTALLA 1: FORMULARIO DE LOGIN (US01)
// ==========================================
// Define la pantalla de Login como un widget que puede cambiar de estado (cambiar de pantalla o mostrar errores)
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

// Clase donde se programa la lógica y la interfaz visual del Login
class _LoginViewState extends State<LoginView> {
  // Captura el texto escrito en la caja de Usuario
  final _usernameController = TextEditingController();
  // Captura el texto escrito en la caja de Contraseña
  final _passwordController = TextEditingController();
  
  // Crea la conexión con la lógica de autenticación
  final _authController = AuthController();

  // Guarda si la app está cargando para mostrar el círculo de espera
  bool _cargando = false;
  // Guarda el mensaje de error si el usuario se equivoca
  String? _errorMessage;

  // Función que se ejecuta al presionar el botón "INGRESAR"
  Future<void> _handleLogin() async {
    // Lee los textos ingresados quitando espacios extra en los bordes
    final username = _usernameController.text.trim();
    // Sirve para obtener la contraseña limpia sin espacios
    final password = _passwordController.text.trim();

    // Sirve para verificar si alguno de los dos campos quedó vacío
    if (username.isEmpty || password.isEmpty) {
      // Sirve para actualizar la pantalla mostrando el mensaje de advertencia
      setState(() {
        _errorMessage = 'Por favor ingresa usuario y contraseña';
      });
      return; // Detiene la función para no intentar conectarse a internet si falta un dato
    }

    // Sirve para refrescar la pantalla activando el círculo de carga y borrando errores previos
    setState(() {
      _cargando = true;
      _errorMessage = null;
    });

    // Empaca las credenciales en un objeto UserModel
    final user = UserModel(username: username, password: password);
    // Envía los datos al controlador para validar el ingreso en el servidor
    final result = await _authController.login(user);

    // Sirve para confirmar que la pantalla siga activa antes de realizar un cambio visual
    if (!mounted) return;

    // Sirve para apagar el indicador de carga una vez que el servidor responde
    setState(() {
      _cargando = false;
    });

    // Sirve para validar si la respuesta del inicio de sesión fue exitosa
    if (result['success']) {
      // Reemplaza la pantalla de Login por la del Catálogo (HomeView) pasando los datos de sesión
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
      // Sirve para mostrar en pantalla el mensaje de error si las credenciales son incorrectas
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  // Se ejecuta automáticamente al cerrar la pantalla para liberar la memoria usada por los campos de texto
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Construye la interfaz gráfica de la pantalla de Login
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
                // Ícono decorativo de candado
                const Icon(Icons.lock_person, size: 80, color: Color(0xFFE040FB)),
                const SizedBox(height: 24),
                
                // Campo de texto para ingresar el usuario
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Campo de texto para ingresar la contraseña (oculta los caracteres)
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Sirve para decidir si se dibuja el texto de error en color rojo en la pantalla
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
                
                // Botón dinámico que cambia entre la animación de carga o el texto "INGRESAR"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  // Sirve para alternar la vista entre el círculo cargando o el botón según la variable _cargando
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
// Define la pantalla del catálogo recibiendo la información del usuario autenticado
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

// Clase donde se gestiona el catálogo, las categorías y el cierre de sesión
class _HomeViewState extends State<HomeView> {
  // Instancia del controlador de productos
  final _productController = ProductController();
  // Guarda la promesa de la lista de productos descargados
  late Future<List<ProductModel>> _futureProducts;
  // Guarda la promesa de la lista de categorías descargadas
  late Future<List<String>> _futureCategories;

  // Variable para saber qué filtro de categoría está presionado
  String? _categoriaSeleccionada;

  // Se ejecuta al iniciar la pantalla: pide categorías y productos iniciales
  @override
  void initState() {
    super.initState();
    _futureCategories = _productController.fetchCategories();
    _cargarProductos();
  }

  // Método interno que decide qué lista de productos traer de la API
  void _cargarProductos() {
    setState(() {
      // Sirve para evaluar si hay un filtro aplicado o si debe traer el catálogo completo
      if (_categoriaSeleccionada == null) {
        _futureProducts = _productController.fetchProducts(); // Trae todos los productos
      } else {
        _futureProducts = _productController.fetchProductsByCategory(_categoriaSeleccionada!); // Trae filtrados
      }
    });
  }

  // Método que activa o desactiva la categoría tocada por el usuario
  void _filtrarPorCategoria(String? categoria) {
    // Sirve para revisar si el usuario volvió a tocar la misma categoría activa para desactivarla
    if (_categoriaSeleccionada == categoria) {
      _categoriaSeleccionada = null; // Quita el filtro
    } else {
      _categoriaSeleccionada = categoria; // Aplica la nueva categoría
    }
    _cargarProductos();
  }

  // Construye la vista del catálogo completo con barra superior, filtros y cuadrícula
  @override
  Widget build(BuildContext context) {
    final authController = AuthController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo (${widget.role})'),
        actions: [
          // Botón con ícono de salida para cerrar la sesión
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFE040FB)),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              // Limpia las credenciales guardadas
              await authController.logout();
              
              // Sirve para validar que la pantalla siga montada antes de realizar la redirección
              if (context.mounted) {
                // Borra todo el historial de pantallas y regresa obligatoriamente al Login
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
          // Renderiza la barra horizontal de filtros por categoría
          FutureBuilder<List<String>>(
            future: _futureCategories,
            builder: (context, snapshot) {
              // Sirve para validar si la API ya envió la lista de categorías
              if (snapshot.hasData) {
                final categorias = snapshot.data ?? [];
                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      // Botón tipo "Chip" para mostrar todos los productos sin filtro
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: const Text('Todos'),
                          selected: _categoriaSeleccionada == null,
                          onSelected: (_) => _filtrarPorCategoria(null),
                        ),
                      ),
                      // Genera un botón "Chip" por cada categoría recibida de la API
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
              return const SizedBox.shrink(); // Espacio invisible mientras cargan las categorías
            },
          ),

          // Renderiza la lista/cuadrícula con las tarjetas de los productos
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                // Sirve para verificar si los productos aún se están descargando de internet
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFE040FB)));
                }

                // Sirve para confirmar si ocurrió un fallo de conexión o error de servidor
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

                // Sirve para comprobar si el filtro o la consulta no devolvió ningún resultado
                if (products.isEmpty) {
                  return const Center(child: Text('No hay productos disponibles.'));
                }

                // Construye la cuadrícula de 2 columnas con los productos
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
                      // Esta línea se ejecuta cuando seleccionas/tocas una tarjeta de producto en el catálogo
                      onTap: () {
                        // Navega a la pantalla de detalle enviando el ID único del producto y el Rol del usuario
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
                              // Muestra la imagen del producto descargada desde su URL
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
                              // Muestra el nombre o título del producto
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
                              // Muestra el precio formateado con dos decimales
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
