import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/CurrencyModelSqfLite.dart';

class CurrencyDbHelper {
  static int version = 1;
  static String dbName = 'CurrencyApp.db';

  Future<Database> _getDbCurrency() async {
    return await openDatabase(
      join(await getDatabasesPath(), dbName),
      version: version,
      singleInstance: true,
      onCreate:
          (db, version) => db.execute(
            'CREATE TABLE Currency ('
            'id INTEGER NOT NULL,'
            'ccy TEXT NOT NULL,'
            'PRIMARY KEY(id AUTOINCREMENT))',
          ),
    );
  }

  Future<void> addCurrency(CurrencyModelSqfLite currency) async {
    final db = await _getDbCurrency();
    final List<Map<String, dynamic>> existingCurrency = await db.query('Currency', where: 'ccy = ?', whereArgs: [currency.ccy]);
    if (existingCurrency.isEmpty) {
      await db.insert('Currency', currency.toJson());
    }
  }

  Future<void> deleteCurrency(String ccy) async {
    final db = await _getDbCurrency();
    await db.delete('Currency', where: 'ccy = ?', whereArgs: [ccy]);
  }

  Future<List<CurrencyModelSqfLite>> getAllCurrency() async {
    try {
      final db = await _getDbCurrency();
      final List<Map<String, dynamic>> queryResult = await db.query('Currency');
      if (queryResult.isEmpty) {
        return [];
      }
      return queryResult.map((json) => CurrencyModelSqfLite.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
