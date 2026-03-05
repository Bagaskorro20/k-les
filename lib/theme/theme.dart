import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- WARNA (COLOR PALETTE) ---
  static const Color primary = Color(0xFF3B2F2F); // Coklat Tua
  static const Color accent = Color(0xFFD4A373); // Emas/Krem Tua
  static const Color background = Color(0xFFF5F1EB); // Krem Muda
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;

  // --- TEXT STYLES (TYPOGRAPHY) ---

  // Judul Besar (Contoh: "Jadwal Mengajar")
  static TextStyle get title => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primary,
  );

  // Sub-Judul (Contoh: "Halo, Guru!")
  static TextStyle get subtitle => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.grey[700],
  );

  // Angka Tanggal (Besar)
  static TextStyle get dateBig =>
      GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold);

  // Nama Hari (Kecil)
  static TextStyle get dateSmall => GoogleFonts.inter(fontSize: 12);

  // Teks di dalam Card (Nama Murid)
  static TextStyle get cardTitle => GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: primary,
  );

  // Teks Kecil di Card (Kelas, Mapel)
  static TextStyle get cardSubtitle =>
      GoogleFonts.inter(color: grey, fontSize: 13);

  // --- THEME DATA GLOBAL ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(seedColor: primary),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        titleTextStyle: title,
        iconTheme: const IconThemeData(color: primary),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: white,
      ),
    );
  }
}
