import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/models.dart';

class BillingCard extends StatelessWidget {
  final MuridModel murid;
  final int totalTagihan;
  final NumberFormat formatRupiah;
  final VoidCallback onCetakPressed; // Fungsi tombol cetak dilempar dari luar

  const BillingCard({
    super.key,
    required this.murid,
    required this.totalTagihan,
    required this.formatRupiah,
    required this.onCetakPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color warnaMurid = Color(murid.colorCode);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [warnaMurid, warnaMurid.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: warnaMurid.withOpacity(0.3),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    murid.nama,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${murid.kelas} • ${murid.mapel}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            "Total Tagihan Berjalan:",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Text(
            formatRupiah.format(totalTagihan),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: warnaMurid,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.print, size: 20),
              label: const Text(
                "Cetak & Kirim Nota (WA)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed:
                  onCetakPressed, // Panggil fungsi yang dikirim dari layar utama
            ),
          ),
        ],
      ),
    );
  }
}
