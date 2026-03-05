import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:k_les/theme/theme.dart';
import 'package:k_les/models/models.dart';

class HabitCalendar extends StatefulWidget {
  final List<RiwayatSesi> riwayatMurid;

  const HabitCalendar({super.key, required this.riwayatMurid});

  @override
  State<HabitCalendar> createState() => _HabitCalendarState();
}

class _HabitCalendarState extends State<HabitCalendar> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: 'Bulan'},
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
        },
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            var riwayatHariIni = widget.riwayatMurid
                .where((r) => isSameDay(r.tanggal, day))
                .toList();

            if (riwayatHariIni.isNotEmpty) {
              bool isHadir = riwayatHariIni.any((r) => r.status == 'Hadir');
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isHadir
                      ? Colors.green.withOpacity(0.2)
                      : Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isHadir ? Colors.green : Colors.redAccent,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isHadir ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                      Icon(
                        isHadir ? Icons.check_circle : Icons.cancel,
                        size: 14,
                        color: isHadir ? Colors.green : Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              );
            }
            return null;
          },
          todayBuilder: (context, day, focusedDay) {
            var riwayatHariIni = widget.riwayatMurid
                .where((r) => isSameDay(r.tanggal, day))
                .toList();
            if (riwayatHariIni.isNotEmpty) {
              bool isHadir = riwayatHariIni.any((r) => r.status == 'Hadir');
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isHadir ? Colors.green : Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${day.day}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(Icons.star, size: 14, color: Colors.white),
                    ],
                  ),
                ),
              );
            }
            return Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
