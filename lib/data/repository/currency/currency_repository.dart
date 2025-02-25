import '../../source/remote/response/currency_response.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyResponse>> getCurrency();

  Future<List<CurrencyResponse>> getCurrencyByDate(String date);

  Future<List<CurrencyResponse>> getCurrencyByCodeAndDate(String code, String date);
}
