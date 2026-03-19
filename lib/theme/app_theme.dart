// ═══════════════════════════════════════════════════════════
//  app_theme.dart
// ═══════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cores principais
  static const Color bg = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color card = Color(0xFF16213E);
  static const Color accent = Color(0xFF7C3AED);
  static const Color accentLight = Color(0xFF9D5CF5);
  static const Color accentDark = Color(0xFF5B21B6);
  static const Color gold = Color(0xFFFFB800);
  static const Color green = Color(0xFF10B981);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);
  static const Color blue = Color(0xFF3B82F6);
  static const Color text = Color(0xFFE2E8F0);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color divider = Color(0xFF2D2D4A);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentLight,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: text,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: text, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(color: text, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: text, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: text),
          bodyMedium: TextStyle(color: textMuted),
          labelLarge: TextStyle(color: text, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: accentLight,
        unselectedItemColor: textMuted,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accent),
        ),
        labelStyle: const TextStyle(color: textMuted),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: accent.withOpacity(0.3),
        labelStyle: const TextStyle(color: text, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: divider),
      ),
    );
  }

  // XP level colors
  static Color xpLevelColor(int nivel) {
    final colors = [
      Colors.grey,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.orange,
      Colors.red,
      const Color(0xFFFFD700),
      const Color(0xFFFF4500),
    ];
    return colors[(nivel - 1).clamp(0, colors.length - 1)];
  }

  // Título do nível
  static String nivelTitulo(int nivel) {
    const titulos = [
      'Iniciante',
      'Aprendiz',
      'Praticante',
      'Competente',
      'Proficiente',
      'Especialista',
      'Mestre',
      'Grão-Mestre',
    ];
    return titulos[(nivel - 1).clamp(0, titulos.length - 1)];
  }

  // XP necessário para o próximo nível
  static int xpParaNivel(int nivel) {
    const xpNiveis = [0, 200, 500, 1000, 2000, 4000, 7000, 12000];
    if (nivel >= xpNiveis.length) return 999999;
    return xpNiveis[nivel];
  }

  // Calcular nível pelo XP
  static int calcularNivel(int xp) {
    const xpNiveis = [0, 200, 500, 1000, 2000, 4000, 7000, 12000];
    int nivel = 1;
    for (int i = 1; i < xpNiveis.length; i++) {
      if (xp >= xpNiveis[i]) nivel = i + 1;
    }
    return nivel.clamp(1, 8);
  }

  // Calcular XP por tipo + dificuldade
  static int calcularXP(String tipo, String dificuldade) {
    const baseXP = {'comum': 15, 'urgente': 30, 'importante': 40, 'critica': 60};
    const multiplicadores = {'facil': 1.0, 'medio': 2.0, 'dificil': 3.0, 'epico': 5.0};
    final base = baseXP[tipo] ?? 15;
    final mult = multiplicadores[dificuldade] ?? 1.0;
    return (base * mult).round();
  }

  // Cores por tipo de tarefa
  static Color corTipo(String tipo) {
    switch (tipo) {
      case 'critica': return red;
      case 'importante': return orange;
      case 'urgente': return blue;
      default: return green;
    }
  }

  // Ícone por tipo
  static IconData iconeTipo(String tipo) {
    switch (tipo) {
      case 'critica': return Icons.priority_high_rounded;
      case 'importante': return Icons.star_rounded;
      case 'urgente': return Icons.flash_on_rounded;
      default: return Icons.check_circle_outline_rounded;
    }
  }
}
