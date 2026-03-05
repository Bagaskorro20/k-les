import 'package:flutter/material.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/widgets/custom_calender.dart';
import 'package:k_les/widgets/schedule_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:k_les/theme/theme.dart';
import 'widgets/calendar_header.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JadwalProvider>().gantiTanggal(_selectedDay!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JadwalProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const CalendarHeader(),

            CustomCalendar(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              hariAktif: provider.hariAktif,
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                });
                provider.gantiTanggal(selected);
              },
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Jadwal: ${DateFormat('EEEE, d MMMM', 'id_ID').format(_selectedDay!)}",
                  style: AppTheme.subtitle.copyWith(
                    fontSize: 15,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.listJadwal.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.coffee, size: 50, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Text(
                            "Waktunya santai! Tidak ada les.",
                            style: AppTheme.dateSmall.copyWith(fontSize: 14),
                          ),
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
    );
  }
}
