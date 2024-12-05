import 'package:holy_quran_app/model/surah_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'holy_quran.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surahNumber INTEGER,
        surahName TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE surahs (
        number INTEGER PRIMARY KEY,
        name TEXT,
        englishName TEXT,
        englishNameTranslation TEXT,
        numberOfAyahs INTEGER,
        revelationType TEXT
      )
    ''');
  }

  // Insert a new bookmark
  Future<void> insertBookmark(int surahNumber, String surahName) async {
    final db = await database;
    await db.insert(
      'bookmarks',
      {'surahNumber': surahNumber, 'surahName': surahName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Insert a new Surah
  Future<void> insertSurah(Surah surah) async {
    final db = await database;
    await db.insert(
      'surahs',
      {
        'number': surah.number,
        'name': surah.name,
        'englishName': surah.englishName,
        'englishNameTranslation': surah.englishNameTranslation,
        'numberOfAyahs': surah.numberOfAyahs,
        'revelationType': surah.revelationType,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Remove a bookmark
  Future<void> removeBookmark(int surahNumber) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'surahNumber = ?',
      whereArgs: [surahNumber],
    );
  }

  // Retrieve all bookmarks
  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await database;
    return await db.query('bookmarks');
  }

  // Fetch all Surahs from the database
  Future<List<Surah>> getSurahs() async {
    final db = await database;
    final List<Map<String, dynamic>> surahMaps = await db.query('surahs');
    return List.generate(surahMaps.length, (i) {
      return Surah(
        number: surahMaps[i]['number'],
        name: surahMaps[i]['name'],
        englishName: surahMaps[i]['englishName'],
        englishNameTranslation: surahMaps[i]['englishNameTranslation'],
        numberOfAyahs: surahMaps[i]['numberOfAyahs'],
        revelationType: surahMaps[i]['revelationType'],
      );
    });
  }
}
