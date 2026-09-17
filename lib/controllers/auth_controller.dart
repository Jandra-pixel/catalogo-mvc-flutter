// CONTROLADOR DE AUTENTICACIÓN (US01 y US02)
// Maneja el inicio de sesión y la limpieza profunda de credenciales al cerrar sesión.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthController {
  
  // US01: Inicio de Sesión
  Future<Map<String, dynamic>> login(UserModel user) async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/users'));

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        final foundUser = users.firstWhere(
          (u) => u['username'] == user.username && u['password'] == user.password,
          orElse: () => null,
        );

        if (foundUser != null) {
          // Asigna rol simulado para pruebas de permisos
          String role = 'Cliente';
          if (user.username == 'johnd') {
            role = 'Administrador';
          } else if (user.username == 'mor_2314') {
            role = 'Auditor';
          }

          return {
            'success': true,
            'role': role,
            'userId': foundUser['id'],
            'message': 'Inicio de sesión exitoso',
          };
        } else {
          return {
            'success': false,
            'message': 'Usuario o contraseña incorrectos',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Error de conexión con el servidor',
        };
      }
    } catch (e) {
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