import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/theme.dart';

class StudentFilterChips extends StatelessWidget {
  final List<String> kategoriList;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const StudentFilterChips({
    super.key,
    required this.kategoriList,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: kategoriList.length,
        itemBuilder: (context, index) {
          String kategori = kategoriList[index];
          bool isSelected = selectedFilter == kategori;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                kategori,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected ? AppTheme.white : Colors.grey[600],
                ),
              ),
              selected: isSelected,
              selectedColor: AppTheme.primary,
              backgroundColor: AppTheme.white,
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: isSelected ? AppTheme.primary : Colors.grey[300]!,
                ),
              ),
              onSelected: (_) => onFilterSelected(kategori),
            ),
          );
        },
      ),
    );
  }
}
