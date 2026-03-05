import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_les/theme/theme.dart';
import 'package:k_les/models/models.dart';
import 'package:k_les/providers/provider.dart';

void showAddDialog(BuildContext context) {
  final provider = context.read<JadwalProvider>();
  DateTime tanggalDipilih = provider.selectedDate;

  MuridModel? muridDipilih;
  TimeOfDay jamDipilih = TimeOfDay.now();
  String formattedJam =
      "${jamDipilih.hour.toString().padLeft(2, '0')}:${jamDipilih.minute.toString().padLeft(2, '0')}";

  final mapelCtrl = TextEditingController();

  List<int> hariDipilih = [tanggalDipilih.weekday];
  final List<String> namaHariList = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  // VARIABEL BARU UNTUK CEKLIS "JADWAL 1X"
  bool isSatuKali = false;

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setState) {
        Future<void> _pilihJam() async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: jamDipilih,
          );
          if (picked != null) {
            setState(() {
              jamDipilih = picked;
              formattedJam =
                  "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
            });
          }
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Tambah Jadwal Les",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),

          content: provider.listMurid.isEmpty
              ? const Text(
                  "Data kontak murid masih kosong.\n\nSilakan daftarkan biodata murid di menu 'Murid' terlebih dahulu.",
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tanggal: ${DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(tanggalDipilih)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- KOTAK CENTANG SESI PENGGANTI ---
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.5),
                          ),
                        ),
                        child: CheckboxListTile(
                          title: const Text(
                            "Jadwal Pengganti (Cuma 1x)",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          subtitle: const Text(
                            "Tidak akan diulang minggu depan",
                            style: TextStyle(fontSize: 11),
                          ),
                          value: isSatuKali,
                          activeColor: Colors.orange,
                          dense: true,
                          onChanged: (val) {
                            setState(() {
                              isSatuKali = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 1. DROPDOWN PILIH MURID
                      const Text(
                        "1. Pilih Murid:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<MuridModel>(
                            isExpanded: true,
                            hint: const Text("Klik untuk memilih murid"),
                            value: muridDipilih,
                            items: provider.listMurid.map((MuridModel murid) {
                              return DropdownMenuItem<MuridModel>(
                                value: murid,
                                child: Text(murid.nama),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                muridDipilih = val;
                                mapelCtrl.text = val!.mapel;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 2. INPUT MAPEL
                      const Text(
                        "2. Pelajaran:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: mapelCtrl,
                        decoration: InputDecoration(
                          hintText: "Contoh: Matematika",
                          prefixIcon: const Icon(Icons.book, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 3. TOMBOL PILIH JAM
                      const Text(
                        "3. Pilih Jam Les:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: _pilihJam,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: AppTheme.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                formattedJam,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "Ubah",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 4. PILIH HARI RUTIN (DISEMBUNYIKAN JIKA isSatuKali DI-CENTANG)
                      if (!isSatuKali) ...[
                        const SizedBox(height: 15),
                        const Text(
                          "4. Pilih Hari Rutin:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const Text(
                          "Bisa pilih lebih dari satu hari",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          spacing: 6.0,
                          runSpacing: -8.0,
                          children: List.generate(7, (index) {
                            int hariAngka = index + 1;
                            bool isSelected = hariDipilih.contains(hariAngka);

                            return FilterChip(
                              label: Text(
                                namaHariList[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppTheme.primary,
                              checkmarkColor: Colors.white,
                              backgroundColor: Colors.grey[200],
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    hariDipilih.add(hariAngka);
                                  } else {
                                    if (hariDipilih.length > 1) {
                                      hariDipilih.remove(hariAngka);
                                    }
                                  }
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            if (provider.listMurid.isNotEmpty)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: AppTheme.white,
                ),
                onPressed: () {
                  if (muridDipilih != null && mapelCtrl.text.isNotEmpty) {
                    if (isSatuKali) {
                      // LOGIKA JIKA CUMA 1X PERTEMUAN (Status 'sekali')
                      final jadwalBaru = JadwalLes(
                        namaMurid: muridDipilih!.nama,
                        kelas: muridDipilih!.kelas,
                        mataPelajaran: mapelCtrl.text,
                        hari: tanggalDipilih.weekday,
                        jam: formattedJam,
                        colorCode: muridDipilih!.colorCode,
                        tipe: 'sekali',
                        tanggalSpesifik: tanggalDipilih.millisecondsSinceEpoch,
                      );
                      provider.tambahJadwal(jadwalBaru);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Jadwal pengganti berhasil dibuat!"),
                        ),
                      );
                    } else {
                      // LOGIKA JADWAL RUTIN (Bisa langsung banyak hari)
                      for (int hari in hariDipilih) {
                        final jadwalBaru = JadwalLes(
                          namaMurid: muridDipilih!.nama,
                          kelas: muridDipilih!.kelas,
                          mataPelajaran: mapelCtrl.text,
                          hari: hari,
                          jam: formattedJam,
                          colorCode: muridDipilih!.colorCode,
                          tipe: 'rutin',
                        );
                        provider.tambahJadwal(jadwalBaru);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Jadwal rutin berhasil dibuat!"),
                        ),
                      );
                    }

                    Navigator.pop(ctx);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pilih murid dan pastikan mapel terisi!"),
                      ),
                    );
                  }
                },
                child: const Text("Simpan Jadwal"),
              ),
          ],
        );
      },
    ),
  );
}
