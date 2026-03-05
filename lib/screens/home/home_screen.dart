import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';
import 'package:k_les/screens/home/widgets/home_header.dart';
import 'package:k_les/screens/home/widgets/horizontal_calendar.dart';
import 'package:k_les/widgets/add_dialog.dart';
import 'package:k_les/widgets/schedule_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JadwalProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const HomeHeader(),

            const SizedBox(height: 25),

            const HorizontalCalendar(),

            const SizedBox(height: 10),

            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.listJadwal.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_note,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10),
                          Text("Tidak ada jadwal", style: AppTheme.dateSmall),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: provider.listJadwal.length,
                      itemBuilder: (context, index) {
                        return ScheduleCard(jadwal: provider.listJadwal[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
