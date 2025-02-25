import 'package:currency_app/data/repository/sqflite/model/CryptoModelSqfLite.dart';
import 'package:currency_app/data/repository/sqflite/model/CurrencyModelSqfLite.dart';

import 'SqfLiteRepository.dart';
import 'crypto_db_helper.dart';
import 'currency_db_helper.dart';

class SqfLiteRepositoryImpl implements SqfLiteRepository {
  final currencyDatabase = CurrencyDbHelper();
  final cryptoDatabase = CryptoDbHelper();

  static final SqfLiteRepositoryImpl _instance = SqfLiteRepositoryImpl._internal();

  SqfLiteRepositoryImpl._internal();

  factory SqfLiteRepositoryImpl() {
    return _instance;
  }

  @override
  Future<void> addCurrency(CurrencyModelSqfLite currency) async {
    await currencyDatabase.addCurrency(currency);
  }

  @override
  Future<void> deleteCurrency(String ccy) async {
    await currencyDatabase.deleteCurrency(ccy);
  }

  @override
  Future<List<CurrencyModelSqfLite>> getAllCurrency() async {
    final list = await currencyDatabase.getAllCurrency();
    return list;
  }

  @override
  Future<void> addCrypto(CryptoModelSqfLite crypto) async {
    await cryptoDatabase.addCrypto(crypto);
  }

  @override
  Future<void> deleteCrypto(String cryptoId) async {
    await cryptoDatabase.deleteCrypto(cryptoId);
  }

  @override
  Future<List<CryptoModelSqfLite>> getAllCrypto() async {
    final list = await cryptoDatabase.getAllCrypto();
    return list;
  }
}
