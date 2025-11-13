import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebTheme {
  ThemeData get darkTheme {
    // ColorScheme é a paleta de cores principal
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF191530),
      brightness: Brightness.dark,
      primary: Colors.white,
      secondary: Color(0xFF361d57),
      surface: Color.fromARGB(255, 18, 16, 58),
    );

    // define o textTheme usando uma fonte do Google Fonts
    final textTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
        .copyWith(
          //personaliza estilos especificos
          displayLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 50,
            color: Colors.white,
          ),
          displayMedium: const TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 20,
            color: Colors.white,
          ),

          labelLarge: const TextStyle(
            // estilo para texto de label
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
          labelMedium: const TextStyle(
            // estilo para texto de botões
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        );
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.primary,
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: Color.fromARGB(255, 233, 172, 41),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Color(0xFFf5b938), width: 1),
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.all(24),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        constraints: BoxConstraints(maxWidth: 400),
        fillColor: Color(0xFFcd90f5).withAlpha(40),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFcd90f5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFf5b938)),
        ),
        hintStyle: TextStyle(color: Color(0xFF9EA2AE)),
      ),

      appBarTheme: AppBarTheme(
        color: colorScheme.secondary,
        titleTextStyle: textTheme.displayLarge?.copyWith(color: Colors.white),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xFFf5b938), width: 1),
        ),
        titleTextStyle: textTheme.displayLarge?.copyWith(color: Colors.white),
        contentTextStyle: textTheme.bodyLarge?.copyWith(color: Colors.white70),
      ),
      iconTheme: IconThemeData(
        color: const Color.fromARGB(255, 235, 184, 28),
        size: 20,
      ),

      cardTheme: CardThemeData(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          //side: BorderSide(color: Color(0xFFf5b938), width: 1)
        ),
        elevation: 4,
      
      
      )
    );
  }
}
