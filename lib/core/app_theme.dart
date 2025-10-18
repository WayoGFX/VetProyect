import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart'; // se importan los colores

// Archivo para configurar el theme del proyecto
final ThemeData
lightTheme = ThemeData(
  useMaterial3: true,

  // Configuración de la tipografía
  textTheme: GoogleFonts.epilogueTextTheme(
    ThemeData.light().textTheme.copyWith(
      // Estilo de texto general del cuerpo (body)
      bodyMedium: TextStyle(
        color: AppColors.textLight,
      ),
      // Estilo de encabezados (h1, h2, h3)
      titleLarge: TextStyle(
        color: AppColors.textLight,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppColors.textLight,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  // 2. Esquema de colores que tenemos
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.textLight, // Texto general
    secondary: AppColors.secondary,
    surface: AppColors.cardLight,
    onSurface: AppColors.textLight,
  ),
);
