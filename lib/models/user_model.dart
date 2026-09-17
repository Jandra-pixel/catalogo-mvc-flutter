//user_model.dart contiene la estructura de datos para almacenar únicamente el usuario y la contraseña, 
//es decir, guarda los datos de la persona que intenta entrar.
class UserModel {
  final int? id; // Guarda un número de identificación (puede estar vacío al principio).
  final String username; // Guarda el texto del nombre de usuario.
  final String password; // Guarda el texto de la contraseña.
  final String? role; // Guarda el tipo de permiso que tiene (Administrador, Cliente, etc.).

  // Esta función sirve para crear el paquete con los datos del usuario.
  UserModel({
    this.id, // Recibe el número de id si lo hay.
    required this.username, // Pide de forma obligatoria el nombre de usuario.
    required this.password, // Pide de forma obligatoria la contraseña.
    this.role, // Recibe el rol si lo hay.
  });

  // Esta función convierte los datos del usuario a un formato de texto simple para enviarlos por internet.
  Map<String, dynamic> toJson() {
    return {
      'username': username, // Pone el nombre de usuario en la lista.
      'password': password, // Pone la contraseña en la lista.
    };
  }

  // Esta regla decide qué tipo de usuario es según su número de id.
  static String determinarRol(int userId) {
    if (userId == 1 || userId == 2) { // Si el número es 1 o 2:
      return 'Administrador'; // Le asigna la palabra Administrador.
    } else if (userId == 3) { // Si el número es 3:
      return 'Auditor'; // Le asigna la palabra Auditor.
    } else { // Si es cualquier otro número:
      return 'Cliente'; // Le asigna la palabra Cliente.
    }
  }
}