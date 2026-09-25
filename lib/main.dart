// Main: Punto de inicio que enciende la aplicación y dibuja la pantalla principal en el dispositivo
// Trae las herramientas básicas de Flutter para dibujar botones, textos y pantallas
import 'package:flutter/material.dart';
// Trae la pantalla de inicio de sesión (login) para mostrarla al abrir la app
import 'views/login_view.dart';

// COLORES DE LA APLICACIÓN (Guardados con nombre para usarlos fácilmente)
// El color negro oscuro para el fondo de las pantallas
const colorNegroFondo = Color(0xFF121212);
// Un negro un poco más claro para las tarjetas o recuadros
const colorNegroTarjeta = Color(0xFF1E1E1E);
// El color morado principal de la app
const colorMoradoPrincipal = Color(0xFF9C27B0);
// Un color lila brillante para resaltar cosas importantes
const colorLilaAccent = Color(0xFFE040FB);
// Un lila clarito para los textos secundarios
const colorLilaSuave = Color(0xFFE1BEE7);

// Aquí inicia la aplicación cuando la abres en el celular o cualquier dispositivo
void main() {
  runApp(const MyApp());
}

// Configuración principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Es la estructura base de toda la app
    return MaterialApp(
      // El nombre oficial de la aplicación
      title: 'Catálogo MVC',
      // Quita la etiqueta roja que dice "DEBUG" en la esquina de la pantalla
      debugShowCheckedModeBanner: false,
      // Le dice a la app que siempre use el modo oscuro
      themeMode: ThemeMode.dark,
      
      // Personalización del diseño del modo oscuro
      darkTheme: ThemeData.dark().copyWith(
        // Pinta el fondo de todas las pantallas con el color negro oscuro
        scaffoldBackgroundColor: colorNegroFondo,
        // Define la paleta de colores para los elementos generales
        colorScheme: const ColorScheme.dark(
          primary: colorMoradoPrincipal,
          secondary: colorLilaAccent,
          surface: colorNegroTarjeta,
        ),
        
        // Cómo se verá la barra superior (la barra del título)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181818), // Fondo de la barra superior
          foregroundColor: Colors.white,      // Color de los iconos y texto
          elevation: 4,                       // La sombra debajo de la barra
          centerTitle: true,                  // Centra el texto del título
          titleTextStyle: TextStyle(          // Tamaño y estilo de la letra del título
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorLilaAccent,
            letterSpacing: 0.5,
          ),
        ),

        // Cómo se verán todos los botones principales de la app
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorMoradoPrincipal, // Color de fondo del botón
            foregroundColor: Colors.white,          // Color de la letra del botón
            elevation: 3,                           // Sombra para que se vea elevado
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Tamaño interno del botón
            shape: RoundedRectangleBorder(          // Redondea las esquinas del botón
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(             // Tamaño de letra dentro del botón
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Cómo se verán las casillas donde el usuario escribe texto (como usuario o contraseña)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,                              // Rellena el fondo de la casilla
          fillColor: const Color(0xFF252525),        // Color gris oscuro para el fondo de la casilla
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Margen interno
          labelStyle: const TextStyle(color: colorLilaSuave), // Color del texto que dice qué escribir
          prefixIconColor: colorLilaAccent,          // Color del icono que va dentro de la casilla
          border: OutlineInputBorder(                // Bordes normales sin línea marcada
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(        // Borde brillante cuando el usuario toca para escribir
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorLilaAccent, width: 2),
          ),
        ),
      ),
      
      // La primera pantalla que se abre al iniciar la aplicación
      home: const LoginView(),
    );
  }
}
