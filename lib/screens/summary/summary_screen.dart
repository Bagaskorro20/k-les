import 'package:flutter/material.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/screens/summary/widgets/weekly_summary_card.dart';
import 'package:k_les/theme/theme.dart';
import 'package:k_les/widgets/stat_card.dart';
import 'package:provider/provider.dart';
import 'widgets/summary_header.dart';
import 'widgets/income_summary_card.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JadwalProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const SummaryHeader(),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IncomeSummaryCard(
                      totalPendapatan: provider.totalPendapatanBulanIni,
                      totalSesi: provider.totalSesiBulanIni,
                    ),

                    const SizedBox(height: 25),

                    WeeklySummaryCard(
                      totalSesi: provider.totalSesiBulanIni.toString(),
                      teksTren: "Seluruh jadwal di database",
                      ikonTren: Icons.assessment_rounded,
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "Ringkasan Data",
                      style: AppTheme.subtitle.copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Murid Aktif",
                            value: provider.listMurid.length.toString(),
                            icon: Icons.people_alt,
                            iconColor: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: StatCard(
                            title: "Total Jadwal",
                            value: provider.totalSesiBulanIni.toString(),
                            icon: Icons.event_available,
                            iconColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
