// user_model.dart contiene la estructura de datos para almacenar únicamente el usuario y la contraseña, 
// es decir, guarda los datos de la persona que intenta entrar.
class UserModel {
  // Número único de identificación (el signo ? significa que puede ser nulo o estar vacío)
  final int? id;
  // Nombre de usuario para iniciar sesión (obligatorio)
  final String username;
  // Contraseña del usuario (obligatoria)
  final String password;
  // Tipo de permiso o rol en la app (opcional, puede ser nulo)
  final String? role;

  // Constructor: Sirve para crear una nueva ficha de usuario con sus datos
  UserModel({
    this.id, // Recibe el ID (opcional)
    required this.username, // Obliga a entregar el nombre de usuario
    required this.password, // Obliga a entregar la contraseña
    this.role, // Recibe el rol (opcional)
  });

  // Convierte los datos del usuario en un formato de texto (JSON) listo para enviarse a un servidor de internet
  Map<String, dynamic> toJson() {
    return {
      'username': username, // Empaca el nombre de usuario
      'password': password, // Empaca la contraseña
    };
  }

  // Función que asigna automáticamente un rol según el número de ID que tenga el usuario
  static String determinarRol(int userId) {
    // Si el ID es 1 o 2, la app lo considera Administrador
    if (userId == 1 || userId == 2) {
      return 'Administrador';
    // Si el ID es 3, le da el rol de Auditor
    } else if (userId == 3) {
      return 'Auditor';
    // Para cualquier otro número de ID (4, 5, 6...), lo asigna como Cliente
    } else {
      return 'Cliente';
    }
  }
}
