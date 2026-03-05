import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<int> hariAktif;
  final Function(DateTime, DateTime) onDaySelected;

  const CustomCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.hariAktif,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JadwalProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TableCalendar(
        locale: 'id_ID',
        firstDay: DateTime.utc(2026, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: focusedDay,
        calendarFormat: CalendarFormat.month,

        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppTheme.subtitle.copyWith(
            color: AppTheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppTheme.primary,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppTheme.primary,
          ),
        ),

        calendarBuilders: CalendarBuilders(
          // FITUR MULTI-WARNA TITIK (MARKER)
          markerBuilder: (context, day, focusedDay) {
            final colors = provider.getColorsForTanggal(day);
            if (colors.isEmpty) return null;

            return Positioned(
              bottom: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                // Maksimal tampilkan 4 titik agar tidak kepanjangan
                children: colors
                    .take(4)
                    .map(
                      (color) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
          // Tanggal terpilih (Bentuk Kopi Tua)
          selectedBuilder: (context, day, focusedDay) {
            return Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
      ),
    );
  }
}
