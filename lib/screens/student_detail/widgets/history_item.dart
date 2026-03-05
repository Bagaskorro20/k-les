import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:k_les/theme/theme.dart';
import 'package:k_les/models/models.dart';

class HistoryItem extends StatelessWidget {
  final RiwayatSesi riwayat;
  final bool isHadir;
  final bool isLunas;
  final NumberFormat formatRupiah;

  const HistoryItem({
    super.key,
    required this.riwayat,
    required this.isHadir,
    required this.isLunas,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isLunas ? Colors.grey[50] : AppTheme.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(
          left: BorderSide(
            color: isLunas
                ? Colors.grey
                : (isHadir ? Colors.green : Colors.redAccent),
            width: 4,
          ),
        ),
        boxShadow: isLunas
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, d MMM yyyy', 'id_ID').format(riwayat.tanggal),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isLunas ? Colors.grey[700] : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(riwayat.mapel, style: AppTheme.cardSubtitle),
            ],
          ),
          isLunas
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isHadir
                          ? formatRupiah.format(riwayat.nominalBayaran)
                          : "Rp 0",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        "✅ Lunas",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  riwayat.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isHadir ? Colors.green : Colors.redAccent,
                  ),
                ),
        ],
      ),
    );
  }
}
