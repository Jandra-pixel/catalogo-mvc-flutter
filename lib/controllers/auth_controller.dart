// CONTROLADOR DE AUTENTICACIÓN (US01 y US02)
// Maneja el inicio de sesión y la limpieza profunda de credenciales al cerrar sesión.

// Herramienta para convertir texto enviado desde internet en datos que la app entienda
import 'dart:convert';
// Herramienta para conectarse a servidores en internet
import 'package:http/http.dart' as http;
// Plantilla del usuario para validar las credenciales
import '../models/user_model.dart';

// Clase que maneja la lógica de entrar y salir de la cuenta de usuario
class AuthController {
  
  // US01: Inicio de Sesión
  Future<Map<String, dynamic>> login(UserModel user) async {
    try {
      // Pide al servidor la lista de usuarios registrados para verificar datos
      final response = await http.get(Uri.parse('https://fakestoreapi.com/users'));

      // Sirve para verificar si el servidor respondió correctamente (código 200). Si la conexión fue exitosa, busca al usuario; si falló la red, salta al else indicando un error de conexión.
      if (response.statusCode == 200) {
        // Convierte la lista de usuarios recibida desde internet
        final List<dynamic> users = jsonDecode(response.body);

        // Busca en la lista un usuario cuyo nombre y contraseña coincidan exactamente con lo ingresado
        final foundUser = users.firstWhere(
          (u) => u['username'] == user.username && u['password'] == user.password,
          orElse: () => null,
        );

        // Sirve para confirmar si se encontró un usuario que coincida con esos datos. Si se encuentra (foundUser no es nulo), asigna el rol y aprueba el ingreso; si no existe, ejecuta el else rechazando las credenciales.
        if (foundUser != null) {
          // Asigna rol simulado para pruebas de permisos
          String role = 'Cliente';
          // Sirve para asignar el rol de 'Administrador' si el nombre de usuario escrito es 'johnd'.
          if (user.username == 'johnd') {
            role = 'Administrador';
          // Sirve para asignar el rol de 'Auditor' si el nombre de usuario escrito es 'mor_2314'.
          } else if (user.username == 'mor_2314') {
            role = 'Auditor';
          }

          // Devuelve una respuesta positiva confirmando que pudo ingresar
          return {
            'success': true,
            'role': role,
            'userId': foundUser['id'],
            'message': 'Inicio de sesión exitoso',
          };
        } else {
          // Devuelve un mensaje de error si el usuario o contraseña no coinciden
          return {
            'success': false,
            'message': 'Usuario o contraseña incorrectos',
          };
        }
      } else {
        // Devuelve un mensaje si la respuesta del servidor no fue el código 200
        return {
          'success': false,
          'message': 'Error de conexión con el servidor',
        };
      }
    } catch (e) {
      // Captura cualquier fallo inesperado durante el proceso (como quedarse sin internet)
      return {
        'success': false,
        'message': 'Error inesperado: $e',
      };
    }
  }

  // US02: Cierre de Sesión y Limpieza Profunda de Memoria
  Future<void> logout() async {
    // Escenario 3 y Reglas de Negocio:
    // Aquí se realiza el borrado de credenciales persistentes (SharedPreferences/Tokens)
    // y el reseteo de variables de sesión locales.
    await Future.delayed(const Duration(milliseconds: 200)); // Simulación de limpieza
  }
}
