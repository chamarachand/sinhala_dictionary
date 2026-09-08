import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sinhala_dictionary_app/core/enums/dictionary_language.dart';
import 'package:sinhala_dictionary_app/core/enums/history_sort_options.dart';
import 'package:sinhala_dictionary_app/core/utils/app_logger.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dictionary.db');

    // Check if the database already exists on the device's storage
    final exists = await databaseExists(path);

    if (!exists) {
      appLog("First launch: Copying database from assets to local storage...");
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy byte data from your assets folder
      ByteData data = await rootBundle.load(join('assets', 'dictionary.db'));
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      // Write the binary data to the user's phone disk
      await File(path).writeAsBytes(bytes, flush: true);
      appLog("Database successfully copied!");
    } else {
      appLog("Database already exists on device. Opening directly.");
    }

    return await openDatabase(
      path,
      readOnly: false,
      onOpen: (db) async {
        await _createUserTables(db);
      },
    );
  }

  Future<void> _createUserTables(Database db) async {
    // Enable Foreign Key checks
    await db.execute('PRAGMA foreign_keys = ON;');

    // 1. Favorites Table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS favorites (
      word_id INTEGER PRIMARY KEY,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (word_id) REFERENCES dictionary (id)
    )
  ''');

    // 2. Search History Table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS search_history (
      word_id INTEGER PRIMARY KEY,
      search_count INTEGER DEFAULT 1,
      last_searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (word_id) REFERENCES dictionary (id)
    )
  ''');
  }

  // Blazing fast search function matching 122k row indexed schema
  Future<List<Map<String, dynamic>>> searchWords(
    String query,
    bool isEnglishToSinhala,
  ) async {
    final db = await database;
    final directionFlag = isEnglishToSinhala ? 'en2sn' : 'sn2en';

    // Using index-friendly queries with a search limit of 40 for ultra-smooth typing responsiveness
    return await db.query(
      'dictionary',
      where: 'word LIKE ? AND direction = ?',
      whereArgs: ['$query%', directionFlag],
      limit: 40,
    );
  }

  /// Favourites related
  Future<bool> isFavourite(int wordId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'word_id = ?',
      whereArgs: [wordId],
    );
    return result.isNotEmpty;
  }

  Future<bool> toggleFavourite(int wordId) async {
    final db = await database;
    final isFav = await isFavourite(wordId);

    if (isFav) {
      await db.delete('favorites', where: 'word_id = ?', whereArgs: [wordId]);
      return false; // Removed
    } else {
      await db.insert('favorites', {
        'word_id': wordId,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      return true; // Added
    }
  }

  Future<List<Map<String, dynamic>>> getFavoriteWords(
    DictionaryLanguage language, {
    SortOptions sortOption = .latest,
  }) async {
    final db = await database;

    final orderByClause = switch (sortOption) {
      .alphabeticalAZ => 'd.word ASC',
      .alphabeticalZA => 'd.word DESC',
      .latest => 'f.created_at DESC',
      _ => 'f.created_at DESC',
    };

    return await db.rawQuery(
      '''
    SELECT d.*, f.created_at
    FROM favorites f
    JOIN dictionary d ON f.word_id = d.id
    WHERE d.direction = ?
    ORDER BY $orderByClause
    ''',
      [language.direction],
    );
  }

  /// History related
  Future<void> addToHistory(int wordId) async {
    final db = await database;
    await db.rawInsert(
      '''
      INSERT INTO search_history (word_id, search_count, last_searched_at)
      VALUES (?, 1, CURRENT_TIMESTAMP)
      ON CONFLICT(word_id) DO UPDATE SET
        search_count = search_count + 1,
        last_searched_at = CURRENT_TIMESTAMP
    ''',
      [wordId],
    );
  }

  Future<void> removeFromHistory(int wordId) async {
    final db = await database;
    await db.delete(
      'search_history',
      where: 'word_id = ?',
      whereArgs: [wordId],
    );
  }

  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('search_history');
  }

  Future<List<Map<String, dynamic>>> getSearchHistory(
    DictionaryLanguage language, {
    SortOptions sortOption = .latest,
  }) async {
    final db = await database;

    final orderByClause = switch (sortOption) {
      .alphabeticalAZ => 'd.word ASC',
      .alphabeticalZA => 'd.word DESC',
      .mostViewed => 'h.search_count DESC, h.last_searched_at DESC',
      .latest => 'h.last_searched_at DESC',
    };

    return await db.rawQuery(
      '''
    SELECT d.*, h.search_count, h.last_searched_at
    FROM search_history h
    JOIN dictionary d ON h.word_id = d.id
    WHERE d.direction = ?
    ORDER BY $orderByClause
    ''',
      [language.direction],
    );
  }
}
