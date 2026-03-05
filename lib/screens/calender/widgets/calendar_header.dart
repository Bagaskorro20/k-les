import 'package:flutter/material.dart';
import '../../../../theme/theme.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Jadwal Bulanan",
                style: AppTheme.subtitle.copyWith(fontSize: 13),
              ),
              Text(
                "Kalender Pintar",
                style: AppTheme.title.copyWith(fontSize: 24),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
