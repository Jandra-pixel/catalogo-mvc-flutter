// CONTROLADOR (Controller):
// Maneja todas las peticiones HTTP HTTP GET hacia la FakeStoreAPI.

// Herramienta para convertir texto enviado desde internet en datos que la app entienda
import 'dart:convert';
// Herramienta para realizar peticiones y conectarse a servidores en internet
import 'package:http/http.dart' as http;
// Plantilla del producto para darle formato a la información recibida
import '../models/product_model.dart';

// Clase que gestiona todas las descargas de datos de productos
class ProductController {
  
  // US03: Obtiene la lista completa de todos los productos del catálogo
  Future<List<ProductModel>> fetchProducts() async {
    // Consulta la dirección web del servidor para traer todos los productos
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

    // Sirve para verificar si el servidor respondió con éxito (código 200). Si la respuesta es correcta, procesa y entrega la lista de productos; si hubo un problema, pasa al else para lanzar el error.
    if (response.statusCode == 200) {
      // Lee el texto de la respuesta y lo transforma en una lista
      final List<dynamic> data = jsonDecode(response.body);
      // Convierte cada elemento de la lista en un objeto de tipo ProductModel
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      // Si la conexión falla, interrumpe el proceso y muestra un error
      throw Exception('Error al cargar los productos');
    }
  }

  // US04: Obtiene la lista de nombres de categorías disponibles (ej: 'electrónica', 'ropa')
  Future<List<String>> fetchCategories() async {
    // Consulta la lista de categorías al servidor
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/categories'));

    // Sirve para confirmar que la lista de categorías se descargó sin errores desde internet. Si es correcto, la convierte en texto; si falla, ejecuta el else.
    if (response.statusCode == 200) {
      // Traduce la respuesta a una lista de datos
      final List<dynamic> data = jsonDecode(response.body);
      // Convierte cada categoría en un texto simple (String)
      return data.map((item) => item.toString()).toList();
    } else {
      // Si hay un problema, lanza una alerta de error
      throw Exception('Error al cargar las categorías');
    }
  }

  // US04: Obtiene únicamente los productos de una categoría específica
  // Esta linea se ejecuta cuando el usuario selecciona una categoría para filtrar los productos
  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    // Consulta los productos filtrados agregando el nombre de la categoría al enlace
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/category/$category'));

    // Sirve para comprobar si el servidor encontró los productos de la categoría seleccionada. Si los encuentra (200), los procesa; si no, salta al else con el mensaje de error.
    if (response.statusCode == 200) {
      // Traduce el texto en una lista
      final List<dynamic> data = jsonDecode(response.body);
      // Convierte cada elemento en un ProductModel con sus datos correspondientes
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      // Lanza una excepción si falla la consulta filtrada
      throw Exception('Error al cargar los productos filtrados');
    }
  }

  // US05: Obtiene la información detallada de un solo producto usando su ID
  // Cuando le damos clic a una imagen se ejecuta este metodo
  /* 
1. La Vista detecta el toque
Al tocar la imagen, Flutter abre la pantalla de detalle pasándole el id del producto seleccionado.

2. El Controlador busca los datos
Al abrirse la pantalla product_detail_view.dart, se ejecuta automáticamente initState() la cual llama a:fetchProductDetail(int id)
el controlador toma el id, consulta y descarga la informacion completa del producto*/

  Future<ProductModel> fetchProductDetail(int id) async {
    // Busca el producto específico en el servidor incluyendo su número identificador
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$id'));

    // Sirve para validar si el producto buscado por su ID existe en el servidor. Si existe (200), arma la ficha del producto; si falla o no existe, ejecuta el else.
    if (response.statusCode == 200) {
      // Traduce el producto individual
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Devuelve la ficha completa armada con ProductModel
      return ProductModel.fromJson(data);
    } else {
      // Notifica si el producto no existe o no se pudo descargar
      throw Exception('Producto no disponible');
    }
  }
}
