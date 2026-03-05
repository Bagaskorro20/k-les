import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';

class HorizontalCalendar extends StatefulWidget {
  const HorizontalCalendar({super.key});

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final ScrollController _dateScrollController = ScrollController();
  final ScrollController _monthScrollController = ScrollController();

  DateTime _focusedMonth = DateTime.now();
  final List<GlobalKey> _monthKeys = List.generate(12, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _scrollToSelectedMonth();
      });
    });
  }

  void _scrollToSelectedDate() {
    final provider = context.read<JadwalProvider>();
    if (_focusedMonth.month == provider.selectedDate.month &&
        _focusedMonth.year == provider.selectedDate.year) {
      int targetDay = provider.selectedDate.day;
      double itemWidth = 80.0;
      double screenWidth = MediaQuery.of(context).size.width;

      double offset =
          ((targetDay - 1) * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      if (_dateScrollController.hasClients) {
        if (offset < 0) offset = 0;
        _dateScrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    } else {
      if (_dateScrollController.hasClients) _dateScrollController.jumpTo(0);
    }
  }

  void _scrollToSelectedMonth() {
    int bulanIndex = _focusedMonth.month - 1;
    final keyContext = _monthKeys[bulanIndex].currentContext;

    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        alignment: 0.4,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JadwalProvider>();
    final int daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            controller: _monthScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 12,
            itemBuilder: (context, index) {
              int bulanKe = index + 1;
              int tahun = DateTime.now().year;
              DateTime bulanItem = DateTime(tahun, bulanKe);
              String namaBulan = DateFormat('MMMM', 'id_ID').format(bulanItem);
              bool isSelected = _focusedMonth.month == bulanKe;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _focusedMonth = DateTime(tahun, bulanKe);
                    _scrollToSelectedDate();
                    _scrollToSelectedMonth();
                  });
                },
                child: Container(
                  key: _monthKeys[index],
                  color: Colors.transparent,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(right: 25),
                  child: Text(
                    namaBulan.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: isSelected ? 24 : 16,
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.w500,
                      color: isSelected ? AppTheme.primary : Colors.grey[300],
                      letterSpacing: isSelected ? 0.5 : 0.0,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 85,
          child: ListView.builder(
            controller: _dateScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final int tanggalAngka = index + 1;
              final DateTime date = DateTime(
                _focusedMonth.year,
                _focusedMonth.month,
                tanggalAngka,
              );

              bool isSelected =
                  provider.selectedDate.year == date.year &&
                  provider.selectedDate.month == date.month &&
                  provider.selectedDate.day == date.day;
              bool isToday =
                  date.day == DateTime.now().day &&
                  date.month == DateTime.now().month &&
                  date.year == DateTime.now().year;

              return GestureDetector(
                onTap: () => provider.gantiTanggal(date),
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : AppTheme.white,
                    border: isToday && !isSelected
                        ? Border.all(color: AppTheme.primary, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      if (!isSelected)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$tanggalAngka",
                        style: AppTheme.dateBig.copyWith(
                          color: isSelected ? AppTheme.white : AppTheme.primary,
                        ),
                      ),
                      Text(
                        DateFormat("E", "id_ID").format(date),
                        style: AppTheme.dateSmall.copyWith(
                          color: isSelected
                              ? AppTheme.white.withOpacity(0.7)
                              : AppTheme.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
