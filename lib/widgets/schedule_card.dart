import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_les/models/models.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';

class ScheduleCard extends StatelessWidget {
  final JadwalLes jadwal;

  const ScheduleCard({super.key, required this.jadwal});

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
    final provider = context.watch<JadwalProvider>();
    String inisial = jadwal.namaMurid.isNotEmpty
        ? jadwal.namaMurid[0].toUpperCase()
        : "?";
    Color warnaMurid = Color(jadwal.colorCode);
    IconData ikonMapel = _getMapelIcon(jadwal.mataPelajaran);

    // Cek apakah hari ini murid ini sudah diabsen?
    bool sudahDiabsen = provider.semuaRiwayat.any(
      (r) =>
          r.namaMurid == jadwal.namaMurid &&
          r.tanggal.year == provider.selectedDate.year &&
          r.tanggal.month == provider.selectedDate.month &&
          r.tanggal.day == provider.selectedDate.day &&
          r.mapel == jadwal.mataPelajaran,
    );

    return Container(
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
        child: Column(
          children: [
            Row(
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
                        jadwal.namaMurid,
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
                              jadwal.kelas,
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
                                  jadwal.mataPelajaran,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        jadwal.jam,
                        style: AppTheme.cardSubtitle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _konfirmasiHapus(context, jadwal.id!),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // --- BAGIAN ABSENSI (MUNCUL DI BAWAH KARTU) ---
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),

            sudahDiabsen
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Sudah direkap untuk hari ini",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // TOMBOL HADIR
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text("Hadir"),
                        onPressed: () => _catatAbsen(context, 'Hadir'),
                      ),
                      // TOMBOL IZIN/BATAL
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text("Izin/Batal"),
                        onPressed: () => _catatAbsen(context, 'Izin/Batal'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  // LOGIKA MENYIMPAN RIWAYAT ABSENSI
  void _catatAbsen(BuildContext context, String status) {
    final provider = context.read<JadwalProvider>();

    // Cari tarif murid ini
    int tarif = 0;
    try {
      final murid = provider.listMurid.firstWhere(
        (m) => m.nama == jadwal.namaMurid,
      );
      tarif = murid.tarifPerSesi;
    } catch (e) {
      tarif = 0;
    }

    // Buat data riwayat baru
    final riwayatBaru = RiwayatSesi(
      namaMurid: jadwal.namaMurid,
      tanggal: provider
          .selectedDate, // Absen untuk tanggal yang sedang dipilih di kalender
      status: status,
      nominalBayaran: status == 'Hadir'
          ? tarif
          : 0, // Kalau izin, tidak dapat uang (0)
      mapel: jadwal.mataPelajaran,
    );

    // Simpan!
    provider.tambahRiwayat(riwayatBaru);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Berhasil mencatat: $status!")));
  }

  void _konfirmasiHapus(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Jadwal"),
        content: const Text("Yakin ingin menghapus jadwal ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              context.read<JadwalProvider>().hapusJadwal(id);
              Navigator.pop(ctx);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
