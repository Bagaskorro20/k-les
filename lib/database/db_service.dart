import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DbService {
  Database? _db;

  final _jadwalStore = intMapStoreFactory.store('jadwal_les');
  final _muridStore = intMapStoreFactory.store('data_murid');
  final _riwayatStore = intMapStoreFactory.store('riwayat_sesi');

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'tutor_mate.db');
    return await databaseFactoryIo.openDatabase(dbPath);
  }

  // --- CRUD JADWAL ---
  Future<int> tambahJadwal(JadwalLes jadwal) async {
    final db = await database;
    return await _jadwalStore.add(db, jadwal.toMap());
  }

  // UPDATE JADWAL PERMANEN
  Future<void> updateJadwal(JadwalLes jadwal) async {
    final db = await database;
    await _jadwalStore.record(jadwal.id!).put(db, jadwal.toMap());
  }

  Future<List<JadwalLes>> getSemuaJadwal() async {
    final db = await database;
    final snapshots = await _jadwalStore.find(db);
    return snapshots.map((s) => JadwalLes.fromMap(s.key, s.value)).toList();
  }

  Future<void> hapusJadwal(int id) async {
    final db = await database;
    await _jadwalStore.record(id).delete(db);
  }

  // --- CRUD MURID ---
  Future<int> tambahMurid(MuridModel murid) async {
    final db = await database;
    return await _muridStore.add(db, murid.toMap());
  }

  Future<List<MuridModel>> getSemuaMurid() async {
    final db = await database;
    final finder = Finder(sortOrders: [SortOrder('nama')]);
    final snapshots = await _muridStore.find(db, finder: finder);
    return snapshots.map((s) => MuridModel.fromMap(s.key, s.value)).toList();
  }

  Future<void> hapusMurid(int id) async {
    final db = await database;
    await _muridStore.record(id).delete(db);
  }

  // --- CRUD RIWAYAT / ABSENSI ---
  Future<int> tambahRiwayat(RiwayatSesi riwayat) async {
    final db = await database;
    return await _riwayatStore.add(db, riwayat.toMap());
  }

  // UPDATE RIWAYAT (Untuk mengubah status jadi Lunas)
  Future<void> updateRiwayat(RiwayatSesi riwayat) async {
    final db = await database;
    await _riwayatStore.record(riwayat.id!).put(db, riwayat.toMap());
  }

  Future<List<RiwayatSesi>> getSemuaRiwayat() async {
    final db = await database;
    final finder = Finder(sortOrders: [SortOrder('tanggal', false)]);
    final snapshots = await _riwayatStore.find(db, finder: finder);
    return snapshots.map((s) => RiwayatSesi.fromMap(s.key, s.value)).toList();
  }
}
