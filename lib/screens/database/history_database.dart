import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/history_model.dart';

class HistoryDatabase {
  static final HistoryDatabase instance = HistoryDatabase._init();
  static Database? _database;

  HistoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scan_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    print('Database path: $path'); // Debug: shows where database is stored

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_history (
        id TEXT PRIMARY KEY,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        isGenerated INTEGER NOT NULL,
        qrImagePath TEXT
      )
    ''');
  }

  Future<void> insertHistory(ScanHistory history) async {
    final db = await instance.database;
    await db.insert('scan_history', history.toMap());
  }

  Future<List<ScanHistory>> getAllHistory() async {
    final db = await instance.database;
    final maps = await db.query(
      'scan_history',
      orderBy: 'timestamp DESC',
    );
    return maps.map((map) => ScanHistory.fromMap(map)).toList();
  }

  Future<void> deleteHistory(String id) async {
    final db = await instance.database;
    await db.delete('scan_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllHistory() async {
    final db = await instance.database;
    await db.delete('scan_history');
  }

  // Debug method to print all records
  Future<void> debugPrintAllRecords() async {
    final db = await instance.database;
    final maps = await db.query('scan_history');
    print('Total records: ${maps.length}');
    for (final map in maps) {
      print('Record: $map');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}