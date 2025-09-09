import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebTheme {
  ThemeData get lightTheme {
    // ColorScheme é a paleta de cores principal
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF191530),
      brightness: Brightness.light,
      primary: Color(0xFF191530),
      secondary: Color(0xFF361d57),
    );

    // define o textTheme usando uma fonte do Google Fonts
    final textTheme =
        GoogleFonts.interTextTheme(
          ThemeData.light().textTheme,
        ).copyWith(
          //personaliza estilos especificos
          displayLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32,
            color: Colors.white,
          ),
          displayMedium: const TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 20, 
            color: Colors.white
          ),
          labelLarge: const TextStyle(
            // estilo para texto de botões
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.white
          ),

        );
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.primary,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFba851a),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Color(0xFFf5b938), width: 1),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.all(16)
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFcd90f5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFf5b938)),
        ),
      ),

      appBarTheme: AppBarTheme(
        color: colorScheme.secondary,
        titleTextStyle: textTheme.displayLarge?.copyWith(color: Colors.white),
      ),

    );
  }
}
