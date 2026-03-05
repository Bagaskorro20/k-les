import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_les/models/models.dart';

class InvoiceReceipt extends StatelessWidget {
  final MuridModel murid;
  final List<RiwayatSesi> riwayatBelumLunas;
  final int totalTagihan;
  final NumberFormat formatRupiah;

  const InvoiceReceipt({
    super.key,
    required this.murid,
    required this.riwayatBelumLunas,
    required this.totalTagihan,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(25),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                const Icon(Icons.school, size: 40, color: Colors.blueAccent),
                const SizedBox(height: 5),
                Text(
                  "TUTOR MATE",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const Text(
                  "Invoice Tagihan Les Privat",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 2, color: Colors.black87),
          const SizedBox(height: 10),
          Text(
            "Nama Murid: ${murid.nama}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            "Tanggal Cetak: ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now())}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 2, color: Colors.black87),
          const SizedBox(height: 15),
          const Text(
            "Rincian Pertemuan:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...riwayatBelumLunas.map((r) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${DateFormat('dd/MM/yy').format(r.tanggal)} - ${r.mapel}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    r.status == 'Hadir'
                        ? formatRupiah.format(r.nominalBayaran)
                        : "Rp 0 (Izin)",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 15),
          const Divider(thickness: 2, color: Colors.black87),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL TAGIHAN:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                formatRupiah.format(totalTagihan),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Center(
            child: Text(
              "Terima kasih atas kepercayaannya! 🙏",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
