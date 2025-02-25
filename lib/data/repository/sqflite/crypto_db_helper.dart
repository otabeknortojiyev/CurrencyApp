import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/CryptoModelSqfLite.dart';

class CryptoDbHelper {
  static int version = 1;
  static String dbName = 'CryptoApp.db';

  Future<Database> _getDbCrypto() async {
    return await openDatabase(
      join(await getDatabasesPath(), dbName),
      version: version,
      singleInstance: true,
      onCreate:
          (db, version) => db.execute(
            'CREATE TABLE Crypto ('
            'id INTEGER NOT NULL,'
            'cryptoId TEXT NOT NULL,'
            'PRIMARY KEY(id AUTOINCREMENT))',
          ),
    );
  }

  Future<void> addCrypto(CryptoModelSqfLite crypto) async {
    final db = await _getDbCrypto();
    final List<Map<String, dynamic>> existingCrypto = await db.query('Crypto', where: 'cryptoId = ?', whereArgs: [crypto.cryptoId]);
    if (existingCrypto.isEmpty) {
      await db.insert('Crypto', crypto.toJson());
    }
  }

  Future<void> deleteCrypto(String cryptoId) async {
    final db = await _getDbCrypto();
    await db.delete('Crypto', where: 'cryptoId = ?', whereArgs: [cryptoId]);
  }

  Future<List<CryptoModelSqfLite>> getAllCrypto() async {
    try {
      final db = await _getDbCrypto();
      final List<Map<String, dynamic>> queryResult = await db.query('Crypto');
      if (queryResult.isEmpty) {
        return [];
      }
      return queryResult.map((json) => CryptoModelSqfLite.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
