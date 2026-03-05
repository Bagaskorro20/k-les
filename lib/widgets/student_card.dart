import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/models/models.dart';
import 'package:k_les/theme/theme.dart';
import 'package:k_les/screens/student_detail/student_detail_screen.dart';

class StudentCard extends StatelessWidget {
  final MuridModel murid;

  const StudentCard({super.key, required this.murid});

  IconData _getMapelIcon(String mapel) {
    if (mapel.toLowerCase().contains("matematika"))
      return Icons.calculate_outlined;
    if (mapel.toLowerCase().contains("fisika") ||
        mapel.toLowerCase().contains("kimia"))
      return Icons.science_outlined;
    if (mapel.toLowerCase().contains("biologi")) return Icons.biotech_outlined;
    if (mapel.toLowerCase().contains("bahasa") ||
        mapel.toLowerCase().contains("inggris"))
      return Icons.language_outlined;
    return Icons.menu_book_outlined;
  }

  @override
  Widget build(BuildContext context) {
    String inisial = murid.nama.isNotEmpty ? murid.nama[0].toUpperCase() : "?";
    Color warnaMurid = Color(murid.colorCode);
    IconData ikonMapel = _getMapelIcon(murid.mapel);

    // BUNGKUS DENGAN INKWELL AGAR BISA DIKLIK
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailScreen(murid: murid),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border(left: BorderSide(color: warnaMurid, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: warnaMurid.withOpacity(0.15),
                child: Text(
                  inisial,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: warnaMurid,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      murid.nama,
                      style: AppTheme.cardTitle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            murid.kelas,
                            style: AppTheme.cardSubtitle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: warnaMurid.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(ikonMapel, size: 14, color: warnaMurid),
                              const SizedBox(width: 4),
                              Text(
                                murid.mapel,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: warnaMurid,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tombol WA saya hilangkan sementara biar kamu fokus klik kartunya,
              // lagipula detail no HP sudah ada di dalam halaman profil.
              Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: () {
                    context.read<JadwalProvider>().hapusMurid(murid.id!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
