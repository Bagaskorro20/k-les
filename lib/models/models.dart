// 1. CETAKAN JADWAL LES
class JadwalLes {
  int? id;
  String namaMurid;
  String kelas;
  String mataPelajaran;
  int hari;
  String jam;
  int colorCode;
  String tipe;
  int? tanggalSpesifik;

  JadwalLes({
    this.id,
    required this.namaMurid,
    required this.kelas,
    required this.mataPelajaran,
    required this.hari,
    required this.jam,
    required this.colorCode,
    this.tipe = 'rutin',
    this.tanggalSpesifik,
  });

  Map<String, dynamic> toMap() => {
    'namaMurid': namaMurid,
    'kelas': kelas,
    'mataPelajaran': mataPelajaran,
    'hari': hari,
    'jam': jam,
    'colorCode': colorCode,
    'tipe': tipe,
    'tanggalSpesifik': tanggalSpesifik,
  };

  factory JadwalLes.fromMap(int id, Map<String, dynamic> map) {
    return JadwalLes(
      id: id,
      namaMurid: map['namaMurid'] ?? '',
      kelas: map['kelas'] ?? '',
      mataPelajaran: map['mataPelajaran'] ?? '',
      hari: (map['hari'] as int?) ?? 1,
      jam: map['jam'] ?? '',
      colorCode: (map['colorCode'] as int?) ?? 0xFF1E88E5,
      tipe: map['tipe'] ?? 'rutin',
      tanggalSpesifik: map['tanggalSpesifik'] as int?,
    );
  }
}

// 2. CETAKAN DATA MURID
class MuridModel {
  int? id;
  String nama;
  String tingkat;
  String kelas;
  String mapel;
  String noHp;
  int tarifPerSesi;
  int colorCode;

  MuridModel({
    this.id,
    required this.nama,
    required this.tingkat,
    required this.kelas,
    required this.mapel,
    required this.noHp,
    this.tarifPerSesi = 0,
    required this.colorCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'tingkat': tingkat,
      'kelas': kelas,
      'mapel': mapel,
      'noHp': noHp,
      'tarifPerSesi': tarifPerSesi,
      'colorCode': colorCode,
    };
  }

  factory MuridModel.fromMap(int id, Map<String, dynamic> map) {
    return MuridModel(
      id: id,
      nama: map['nama'] ?? '',
      tingkat: map['tingkat'] ?? '',
      kelas: map['kelas'] ?? '',
      mapel: map['mapel'] ?? '',
      noHp: map['noHp'] ?? '',
      tarifPerSesi: (map['tarifPerSesi'] as int?) ?? 0,
      colorCode: (map['colorCode'] as int?) ?? 0xFF1E88E5,
    );
  }
}

// 3. CETAKAN RIWAYAT ABSENSI (DIUPDATE)
class RiwayatSesi {
  int? id;
  String namaMurid;
  DateTime tanggal;
  String status;
  int nominalBayaran;
  String mapel;
  bool isDicetak;

  RiwayatSesi({
    this.id,
    required this.namaMurid,
    required this.tanggal,
    required this.status,
    required this.nominalBayaran,
    required this.mapel,
    this.isDicetak = false,
  });

  Map<String, dynamic> toMap() => {
    'namaMurid': namaMurid,
    'tanggal': tanggal.millisecondsSinceEpoch,
    'status': status,
    'nominalBayaran': nominalBayaran,
    'mapel': mapel,
    'isDicetak': isDicetak,
  };

  factory RiwayatSesi.fromMap(int id, Map<String, dynamic> map) {
    return RiwayatSesi(
      id: id,
      namaMurid: map['namaMurid'] ?? '',
      tanggal: DateTime.fromMillisecondsSinceEpoch(
        map['tanggal'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      status: map['status'] ?? 'Hadir',
      nominalBayaran: (map['nominalBayaran'] as int?) ?? 0,
      mapel: map['mapel'] ?? '',
      isDicetak: map['isDicetak'] ?? false,
    );
  }
}
