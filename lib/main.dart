import 'package:flutter/material.dart';
import 'views/login_view.dart';

// CONSTANTES GLOBALES DE COLOR
const colorNegroFondo = Color(0xFF121212);
const colorNegroTarjeta = Color(0xFF1E1E1E);
const colorMoradoPrincipal = Color(0xFF9C27B0);
const colorLilaAccent = Color(0xFFE040FB);
const colorLilaSuave = Color(0xFFE1BEE7);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo MVC',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: colorNegroFondo,
        colorScheme: const ColorScheme.dark(
          primary: colorMoradoPrincipal,
          secondary: colorLilaAccent,
          surface: colorNegroTarjeta,
        ),
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF181818),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorLilaAccent,
            letterSpacing: 0.5,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorMoradoPrincipal,
            foregroundColor: Colors.white,
            elevation: 3,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF252525),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: const TextStyle(color: colorLilaSuave),
          prefixIconColor: colorLilaAccent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: colorLilaAccent, width: 2),
          ),
        ),
      ),
      
      home: const LoginView(),
    );
  }
}