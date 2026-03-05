import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../database/db_service.dart';

class JadwalProvider extends ChangeNotifier {
  final DbService _db = DbService();

  List<JadwalLes> listJadwal = [];
  List<JadwalLes> semuaJadwalLengkap = [];
  List<int> hariAktif = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = true;
  String? fotoProfilPath;
  List<MuridModel> listMurid = [];
  bool isLoadingMurid = true;
  List<RiwayatSesi> semuaRiwayat = [];
  int totalSesiBulanIni = 0;
  int totalPendapatanBulanIni = 0;

  JadwalProvider() {
    _init();
  }

  void _init() {
    loadJadwal();
    loadHariAktif();
    loadFotoProfil();
    loadMurid();
    loadRiwayat();
  }

  // --- LOGIKA RIWAYAT / ABSENSI ---
  Future<void> loadRiwayat() async {
    semuaRiwayat = await _db.getSemuaRiwayat();
    hitungStatistikAkurat();
    notifyListeners();
  }

  Future<void> tambahRiwayat(RiwayatSesi riwayat) async {
    await _db.tambahRiwayat(riwayat);
    loadRiwayat();
  }

  void hitungStatistikAkurat() {
    final now = DateTime.now();
    int sesiBerjalan = 0;
    int uangTerkumpul = 0;

    for (var riwayat in semuaRiwayat) {
      if (riwayat.tanggal.month == now.month &&
          riwayat.tanggal.year == now.year) {
        if (riwayat.status == 'Hadir') {
          sesiBerjalan++;
          uangTerkumpul += riwayat.nominalBayaran;
        }
      }
    }
    totalSesiBulanIni = sesiBerjalan;
    totalPendapatanBulanIni = uangTerkumpul;
    notifyListeners();
  }

  // ==========================================
  // FITUR BARU: MESIN KASIR & NOTA TAGIHAN
  // ==========================================

  // 1. Fungsi melunasi tagihan (Merubah status isDicetak jadi TRUE)
  Future<void> lunasiTagihanMurid(String namaMurid) async {
    // (isDicetak == false)
    final riwayatBelumLunas = semuaRiwayat
        .where((r) => r.namaMurid == namaMurid && r.isDicetak == false)
        .toList();

    // Ubah status semuanya jadi LUNAS (true) di database
    for (var riwayat in riwayatBelumLunas) {
      riwayat.isDicetak = true;
      await _db.updateRiwayat(riwayat);
    }

    // Refresh data di layar
    await loadRiwayat();
  }

  // --- LOGIKA MURID ---
  Future<void> loadMurid() async {
    isLoadingMurid = true;
    notifyListeners();
    listMurid = await _db.getSemuaMurid();
    isLoadingMurid = false;
    notifyListeners();
  }

  Future<void> tambahMurid(MuridModel murid) async {
    await _db.tambahMurid(murid);
    loadMurid();
  }

  Future<void> hapusMurid(int id) async {
    await _db.hapusMurid(id);
    loadMurid();
  }

  // --- LOGIKA FOTO ---
  Future<void> loadFotoProfil() async {
    final prefs = await SharedPreferences.getInstance();
    fotoProfilPath = prefs.getString('foto_profil');
    notifyListeners();
  }

  Future<void> setFotoProfil(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('foto_profil', path);
    fotoProfilPath = path;
    notifyListeners();
  }

  // --- LOGIKA JADWAL & KALENDER YANG DIPERBARUI ---
  Future<void> loadHariAktif() async {
    semuaJadwalLengkap = await _db.getSemuaJadwal();
    // (Pewarnaan kalender sementara kita biarkan mengandalkan hari rutin agar tidak berat,
    // karena titik warna itu cuma sebagai panduan visual bulan)
    hariAktif = semuaJadwalLengkap.map((j) => j.hari).toSet().toList();
    notifyListeners();
  }

  // Pewarnaan titik penanda di bawah kalender
  List<Color> getColorsForTanggal(DateTime date) {
    final jadwalDiHariItu = semuaJadwalLengkap.where((j) {
      if (j.tipe == 'rutin') return j.hari == date.weekday;
      if (j.tanggalSpesifik != null) {
        final tgl = DateTime.fromMillisecondsSinceEpoch(j.tanggalSpesifik!);
        return tgl.year == date.year &&
            tgl.month == date.month &&
            tgl.day == date.day;
      }
      return false;
    });
    return jadwalDiHariItu.map((j) => Color(j.colorCode)).toSet().toList();
  }

  void gantiTanggal(DateTime date) {
    selectedDate = date;
    loadJadwal();
  }

  // FUNGSI FILTER: Mana yang rutin, mana yang jadwal pengganti (sekali)
  Future<void> loadJadwal() async {
    isLoading = true;
    notifyListeners();
    final semua = await _db.getSemuaJadwal();

    listJadwal = semua.where((j) {
      // 1. Jika jadwal rutin, cek apakah harinya sama (misal sama-sama Selasa)
      if (j.tipe == 'rutin') {
        return j.hari == selectedDate.weekday;
      }
      // 2. Jika jadwal "sekali", cek apakah tanggal, bulan, dan tahunnya persis sama
      else {
        if (j.tanggalSpesifik != null) {
          final tglSpesifik = DateTime.fromMillisecondsSinceEpoch(
            j.tanggalSpesifik!,
          );
          return tglSpesifik.year == selectedDate.year &&
              tglSpesifik.month == selectedDate.month &&
              tglSpesifik.day == selectedDate.day;
        }
        return false;
      }
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  Future<void> tambahJadwal(JadwalLes jadwal) async {
    await _db.tambahJadwal(jadwal);
    loadJadwal();
    loadHariAktif();
  }

  // UPDATE JADWAL PERMANEN
  Future<void> updateJadwal(JadwalLes jadwal) async {
    await _db.updateJadwal(jadwal);
    loadJadwal();
    loadHariAktif();
  }

  Future<void> hapusJadwal(int id) async {
    await _db.hapusJadwal(id);
    loadJadwal();
    loadHariAktif();
  }
}
