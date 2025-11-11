import 'package:flutter/material.dart';

// clase de los colores para el tema

class AppColors {
  // Paleta Principal
  static const Color primary = Color(
    0xFF8CD0F2,
  ); // primary: #8cd0f2
  static const Color secondary = Color(
    0xFFF4C7C7,
  ); // secondary: #f4c7c7

  // Colores de Fondo y Superficie
  static const Color backgroundLight = Color(
    0xFFFDFCFE,
  ); // background-light: #fdfcff
  static const Color cardLight = Color(
    0xFFFFFFFF,
  ); // card-light: #ffffff

  // Colores de Texto
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color textLight = Color(
    0xFF1E293B,
  ); // text-slate-800 / text-slate-900 (oscuro)
  static const Color slate400Light = Color(
    0xFF94A3B8,
  ); // text-slate-400
  static const Color slate500Light = Color(
    0xFF64748B,
  ); // text-slate-500
  static const Color slate600Light = Color(
    0xFF475569,
  ); // text-slate-600
  static const Color slate50Light = Color(
    0xFFF8FAFC,
  ); // bg-slate-50

  // Colores de error
  static const Color dangerText = Color(
    0xFFC70039,
  );

  // Plantilla para opacidades
  static Color primary20 = AppColors.primary.withOpacity(
    0.2,
  ); // bg-primary/20

  static Color black60 = AppColors.black.withOpacity(
    0.6,
  ); // text-black/60
  static Color black40 = AppColors.black.withOpacity(
    0.4,
  ); // text-black/40
  static Color black05 = AppColors.black.withOpacity(
    0.05,
  ); // border-black/5

  static Color slateBorder = const Color(
    0xFFE2E8F0,
  ); // border-slate-100
}
