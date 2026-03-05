import 'package:flutter/material.dart';
import 'package:k_les/models/models.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:k_les/screens/student/widgets/add_student_dialog.dart';
import 'package:k_les/widgets/student_card.dart';
import 'widgets/student_header.dart';
import 'widgets/student_search_bar.dart';
import 'widgets/student_filter_chips.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String _selectedFilter = "Semua";
  String _searchQuery = "";
  final List<String> _kategori = ["Semua", "SD", "SMP", "SMA"];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JadwalProvider>();

    List<MuridModel> filteredMurid = provider.listMurid.where((murid) {
      bool matchFilter =
          _selectedFilter == "Semua" || murid.tingkat == _selectedFilter;

      bool matchSearch = murid.nama.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      return matchFilter && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const StudentHeader(),

            StudentSearchBar(
              onChanged: (text) {
                setState(() {
                  _searchQuery = text;
                });
              },
            ),

            StudentFilterChips(
              kategoriList: _kategori,
              selectedFilter: _selectedFilter,
              onFilterSelected: (kategori) {
                setState(() {
                  _selectedFilter = kategori;
                });
              },
            ),

            const SizedBox(height: 10),

            Expanded(
              child: provider.isLoadingMurid
                  ? const Center(child: CircularProgressIndicator())
                  : filteredMurid.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Tidak ada data ditemukan.",
                            style: AppTheme.subtitle,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      itemCount: filteredMurid.length,
                      itemBuilder: (context, index) {
                        return StudentCard(murid: filteredMurid[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primary,
        onPressed: () => showAddStudentDialog(context),
        icon: const Icon(Icons.person_add, color: AppTheme.white),
        label: const Text(
          "Murid Baru",
          style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
