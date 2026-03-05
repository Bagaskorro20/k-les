import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_les/theme/theme.dart';

class WeeklySummaryCard extends StatelessWidget {
  // Nanti variabel ini bisa diisi dari database Sembast!
  final String totalSesi;
  final String teksTren;
  final IconData ikonTren;

  const WeeklySummaryCard({
    super.key,
    this.totalSesi = "12",
    this.teksTren = "+3 sesi dari minggu lalu",
    this.ikonTren = Icons.trending_up,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFF5A4A4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Minggu Ini",
                style: GoogleFonts.inter(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(ikonTren, color: AppTheme.accent),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                totalSesi,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "Sesi Les",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              teksTren,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
