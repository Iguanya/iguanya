// lib/services/storage.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/account.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'accounting.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE accounts(
            id TEXT PRIMARY KEY,
            name TEXT,
            balance REAL
          )
        ''');
      },
    );
  }

  Future<void> insertAccount(Account account) async {
    final db = await database;
    await db.insert('accounts', account.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return List.generate(maps.length, (i) {
      return Account(
        id: maps[i]['id'],
        name: maps[i]['name'],
        balance: maps[i]['balance'],
      );
    });
  }
}
