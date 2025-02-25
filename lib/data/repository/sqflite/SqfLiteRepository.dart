import 'model/CryptoModelSqfLite.dart';
import 'model/CurrencyModelSqfLite.dart';

abstract class SqfLiteRepository {
  Future<void> addCurrency(CurrencyModelSqfLite currency);

  Future<void> deleteCurrency(String ccy);

  Future<List<CurrencyModelSqfLite>> getAllCurrency();

  Future<void> addCrypto(CryptoModelSqfLite crypto);

  Future<void> deleteCrypto(String cryptoId);

  Future<List<CryptoModelSqfLite>> getAllCrypto();
}
