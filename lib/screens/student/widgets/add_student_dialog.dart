import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_les/models/models.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';

void showAddStudentDialog(BuildContext context) {
  final namaCtrl = TextEditingController();
  final kelasCtrl = TextEditingController();
  final mapelCtrl = TextEditingController();
  final noHpCtrl = TextEditingController();
  final tarifCtrl = TextEditingController(); // <--- KONTROLER BARU UNTUK TARIF

  String tingkatDipilih = 'SD';

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Murid Baru",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _inputField(namaCtrl, "Nama Lengkap", Icons.person),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: tingkatDipilih,
                      items: ['SD', 'SMP', 'SMA']
                          .map(
                            (String val) =>
                                DropdownMenuItem(value: val, child: Text(val)),
                          )
                          .toList(),
                      onChanged: (newVal) =>
                          setState(() => tingkatDipilih = newVal!),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                _inputField(kelasCtrl, "Detail Kelas (ex: 6 SD)", Icons.school),
                const SizedBox(height: 10),
                _inputField(mapelCtrl, "Mata Pelajaran", Icons.book),
                const SizedBox(height: 10),
                _inputField(
                  noHpCtrl,
                  "No. WhatsApp",
                  Icons.phone,
                  isNumber: true,
                ),
                const SizedBox(height: 10),

                // KOLOM INPUT TARIF BAYARAN
                _inputField(
                  tarifCtrl,
                  "Tarif per Pertemuan (Rp)",
                  Icons.payments_outlined,
                  isNumber: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.white,
              ),
              onPressed: () {
                if (namaCtrl.text.isNotEmpty) {
                  // Ubah teks tarif ke angka (jika kosong anggap 0)
                  int tarifInt = tarifCtrl.text.isNotEmpty
                      ? int.parse(tarifCtrl.text)
                      : 0;
                  final List<int> pilihanWarna = [
                    0xFFE53935,
                    0xFF43A047,
                    0xFF1E88E5,
                    0xFFFFB300,
                    0xFF8E24AA,
                    0xFF00ACC1,
                    0xFFF4511E,
                  ];
                  int warnaAcak =
                      pilihanWarna[Random().nextInt(pilihanWarna.length)];

                  final muridBaru = MuridModel(
                    nama: namaCtrl.text,
                    tingkat: tingkatDipilih,
                    kelas: kelasCtrl.text,
                    mapel: mapelCtrl.text,
                    noHp: noHpCtrl.text,
                    tarifPerSesi: tarifInt,
                    colorCode: warnaAcak,
                  );
                  context.read<JadwalProvider>().tambahMurid(muridBaru);
                  Navigator.pop(ctx);
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    ),
  );
}

Widget _inputField(
  TextEditingController ctrl,
  String label,
  IconData icon, {
  bool isNumber = false,
}) {
  return TextField(
    controller: ctrl,
    keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    ),
  );
}
