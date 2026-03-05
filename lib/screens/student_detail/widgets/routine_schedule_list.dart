import 'package:flutter/material.dart';
import '../../../../models/models.dart';
import 'package:k_les/theme/theme.dart';

class RoutineScheduleList extends StatelessWidget {
  final List<JadwalLes> jadwalRutin;
  final Color warnaMurid;
  final Function(JadwalLes)
  onEditPressed; // Fungsi edit minta parameter JadwalLes

  const RoutineScheduleList({
    super.key,
    required this.jadwalRutin,
    required this.warnaMurid,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> namaHariList = [
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu",
      "Minggu",
    ];

    if (jadwalRutin.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("Belum ada jadwal rutin."),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: jadwalRutin.length,
      itemBuilder: (context, index) {
        final jadwal = jadwalRutin[index];
        String namaHari = namaHariList[jadwal.hari - 1];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.event_repeat, color: warnaMurid, size: 20),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Setiap $namaHari",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "${jadwal.jam} • ${jadwal.mataPelajaran}",
                      style: AppTheme.cardSubtitle,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_calendar, color: Colors.blueAccent),
                onPressed: () => onEditPressed(
                  jadwal,
                ), // Lempar jadwal yg mau diedit ke layar utama
              ),
            ],
          ),
        );
      },
    );
  }
}
