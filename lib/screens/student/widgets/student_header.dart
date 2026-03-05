import 'package:flutter/material.dart';
import '../../../../theme/theme.dart';

class StudentHeader extends StatelessWidget {
  const StudentHeader({super.key});

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
                "Direktori",
                style: AppTheme.subtitle.copyWith(fontSize: 13),
              ),
              Text("Data Murid", style: AppTheme.title.copyWith(fontSize: 24)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.people_alt,
              color: AppTheme.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
