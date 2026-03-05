import 'package:flutter/material.dart';
import 'package:k_les/providers/provider.dart';
import 'package:k_les/theme/theme.dart';
import 'dart:io'; // Untuk membaca File gambar dari HP
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart'; // Untuk buka galeri

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  // Fungsi untuk membuka galeri dan memilih foto
  Future<void> _pilihFoto(BuildContext context) async {
    final picker = ImagePicker();
    // Membuka galeri HP
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    // Jika user jadi memilih foto (tidak batal)
    if (pickedFile != null) {
      // Simpan fotonya pakai Provider
      context.read<JadwalProvider>().setFotoProfil(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Panggil provider untuk mengecek apakah ada foto yang tersimpan
    final provider = context.watch<JadwalProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TEKS HALO
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Halo, Guru!",
                style: AppTheme.subtitle.copyWith(fontSize: 16),
              ),
              Text(
                "Jadwal Mengajar",
                style: AppTheme.title.copyWith(fontSize: 28),
              ),
            ],
          ),

          // FOTO PROFIL BISA DI-KLIK
          GestureDetector(
            onTap: () => _pilihFoto(context),
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  18,
                ), // Bentuk melengkung yang modern
                // Cek apakah ada foto di memori? Jika ada, tampilkan.
                image: provider.fotoProfilPath != null
                    ? DecorationImage(
                        image: FileImage(File(provider.fotoProfilPath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              // Jika TIDAK ADA foto, tampilkan Icon Kamera/Orang sebagai default
              child: provider.fotoProfilPath == null
                  ? const Icon(
                      Icons.add_a_photo,
                      color: AppTheme.primary,
                      size: 24,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
