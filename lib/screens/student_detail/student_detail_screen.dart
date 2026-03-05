import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:k_les/models/models.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'widgets/history_item.dart';
import 'widgets/invoice_receipt.dart';
import 'widgets/habit_calendar.dart';
import 'widgets/billing_card.dart';
import 'widgets/routine_schedule_list.dart';

class StudentDetailScreen extends StatefulWidget {
  final MuridModel murid;
  const StudentDetailScreen({super.key, required this.murid});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JadwalProvider>();
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    Color warnaMurid = Color(widget.murid.colorCode);

    // Filter Data
    final riwayatMurid = provider.semuaRiwayat
        .where((r) => r.namaMurid == widget.murid.nama)
        .toList();
    final riwayatBelumLunas = riwayatMurid
        .where((r) => r.isDicetak == false)
        .toList();
    final riwayatLunas = riwayatMurid
        .where((r) => r.isDicetak == true)
        .toList();
    int totalTagihan = riwayatBelumLunas
        .where((r) => r.status == 'Hadir')
        .fold(0, (sum, item) => sum + item.nominalBayaran);

    final jadwalRutin = provider.semuaJadwalLengkap
        .where((j) => j.namaMurid == widget.murid.nama && j.tipe == 'rutin')
        .toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primary),
        title: Text(
          "Profil Murid",
          style: AppTheme.subtitle.copyWith(
            color: AppTheme.primary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. KARTU TAGIHAN (Widget Terpisah)
            BillingCard(
              murid: widget.murid,
              totalTagihan: totalTagihan,
              formatRupiah: formatRupiah,
              onCetakPressed: () => _prosesCetakNota(
                context,
                provider,
                riwayatBelumLunas,
                totalTagihan,
                formatRupiah,
              ),
            ),
            const SizedBox(height: 20),

            // 2. JADWAL RUTIN (Widget Terpisah)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Jadwal Rutin",
                style: AppTheme.subtitle.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            RoutineScheduleList(
              jadwalRutin: jadwalRutin,
              warnaMurid: warnaMurid,
              onEditPressed: (jadwal) => _showEditJadwalDialog(context, jadwal),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 30),
            ),

            // 3. KALENDER HABIT TRACKER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Kalender Kehadiran",
                style: AppTheme.subtitle.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            HabitCalendar(riwayatMurid: riwayatMurid),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(height: 10),
            ),

            // 4. BAGIAN A: SESI BERJALAN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Sesi Berjalan (Belum Ditagih)",
                style: AppTheme.subtitle.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            riwayatBelumLunas.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Bersih! Belum ada tagihan baru.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: riwayatBelumLunas.length,
                    itemBuilder: (context, index) {
                      final riwayat = riwayatBelumLunas[index];
                      return HistoryItem(
                        riwayat: riwayat,
                        isHadir: riwayat.status == 'Hadir',
                        isLunas: false,
                        formatRupiah: formatRupiah,
                      );
                    },
                  ),
            const SizedBox(height: 15),

            // 5. BAGIAN B: ARSIP LAMA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Arsip Lama (Sudah Lunas)",
                style: AppTheme.subtitle.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            riwayatLunas.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Belum ada arsip.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: riwayatLunas.length,
                    itemBuilder: (context, index) {
                      final riwayat = riwayatLunas[index];
                      return HistoryItem(
                        riwayat: riwayat,
                        isHadir: riwayat.status == 'Hadir',
                        isLunas: true,
                        formatRupiah: formatRupiah,
                      );
                    },
                  ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA UTAMA (TIDAK BERUBAH) ---

  Future<void> _prosesCetakNota(
    BuildContext context,
    JadwalProvider provider,
    List<RiwayatSesi> riwayatBelumLunas,
    int totalTagihan,
    NumberFormat formatRupiah,
  ) async {
    if (riwayatBelumLunas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Belum ada tagihan baru untuk dicetak.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final imageBytes = await screenshotController.captureFromWidget(
        InvoiceReceipt(
          murid: widget.murid,
          riwayatBelumLunas: riwayatBelumLunas,
          totalTagihan: totalTagihan,
          formatRupiah: formatRupiah,
        ),
        delay: const Duration(milliseconds: 100),
        context: context,
      );

      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/Nota_${widget.murid.nama.replaceAll(' ', '_')}.jpg';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);

      // --- PERBAIKAN SATPAM (Pakai context.mounted) ---
      if (!context.mounted) return;

      Navigator.pop(context); // Tutup loading

      String pesanWA =
          "Halo Bapak/Ibu, berikut adalah rincian tagihan les ananda *${widget.murid.nama}* sebesar *${formatRupiah.format(totalTagihan)}*.\n\nTerima kasih! 🙏";
      await SharePlus.instance.share(
        ShareParams(text: pesanWA, files: [XFile(imagePath)]),
      );

      // --- PERBAIKAN SATPAM ---
      if (!context.mounted) return;

      _tanyaResetLunas(context, provider);
    } catch (e) {
      // --- PERBAIKAN SATPAM ---
      if (!context.mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal mencetak: $e")));
    }
  }

  void _tanyaResetLunas(BuildContext context, JadwalProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset Tagihan?"),
        content: const Text(
          "Apakah nota sudah berhasil dikirim ke WhatsApp orang tua?\n\nJika Ya, tagihan akan di-reset jadi Rp 0 dan riwayat akan dipindah ke Arsip Lunas.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Belum"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              provider.lunasiTagihanMurid(widget.murid.nama);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tagihan lunas & di-reset! ✅")),
              );
            },
            child: const Text(
              "Ya, Lunas!",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditJadwalDialog(BuildContext context, JadwalLes jadwalLama) {
    final mapelCtrl = TextEditingController(text: jadwalLama.mataPelajaran);
    List<String> jamSplit = jadwalLama.jam.split(":");
    TimeOfDay jamDipilih = TimeOfDay(
      hour: int.parse(jamSplit[0]),
      minute: int.parse(jamSplit[1]),
    );
    String formattedJam = jadwalLama.jam;
    int hariDipilih = jadwalLama.hari;
    final List<String> namaHariList = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          Future<void> _pilihJam() async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: jamDipilih,
            );
            if (picked != null)
              setState(() {
                jamDipilih = picked;
                formattedJam =
                    "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
              });
          }

          return AlertDialog(
            title: const Text("Pindah Jadwal Permanen"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<int>(
                    isExpanded: true,
                    value: hariDipilih,
                    items: List.generate(
                      7,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text(namaHariList[index]),
                      ),
                    ),
                    onChanged: (val) => setState(() => hariDipilih = val!),
                  ),
                  InkWell(
                    onTap: _pilihJam,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Jam: $formattedJam (Ubah)",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: mapelCtrl,
                    decoration: const InputDecoration(labelText: "Pelajaran"),
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
                onPressed: () {
                  final jadwalDiupdate = JadwalLes(
                    id: jadwalLama.id,
                    namaMurid: jadwalLama.namaMurid,
                    kelas: jadwalLama.kelas,
                    mataPelajaran: mapelCtrl.text,
                    hari: hariDipilih,
                    jam: formattedJam,
                    colorCode: jadwalLama.colorCode,
                    tipe: 'rutin',
                  );
                  context.read<JadwalProvider>().updateJadwal(jadwalDiupdate);
                  Navigator.pop(ctx);
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      ),
    );
  }
}
