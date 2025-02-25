import 'package:currency_app/data/source/remote/response/currency_response.dart';
import 'package:currency_app/data/source/remote/service/currency_service.dart';

import 'currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final service = CurrencyService();

  @override
  Future<List<CurrencyResponse>> getCurrency() async {
    return await service.getCurrency();
  }

  @override
  Future<List<CurrencyResponse>> getCurrencyByCodeAndDate(String code, String date) async {
    return await service.getCurrencyByCodeAndDate(code, date);
  }

  @override
  Future<List<CurrencyResponse>> getCurrencyByDate(String date) async {
    return await service.getCurrencyByDate(date);
  }
}
