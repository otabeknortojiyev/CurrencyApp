import 'package:dio/dio.dart';

import '../response/currency_response.dart';

class CurrencyService {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://cbu.uz/uz/',
      contentType: 'application/json',
      receiveTimeout: Duration(seconds: 30),
      connectTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      receiveDataWhenStatusError: true,
    ),
  );

  Future<List<CurrencyResponse>> getCurrency() async {
    try {
      final response = await dio.get('arkhiv-kursov-valyut/json/');
      return (response.data as List).map((element) => CurrencyResponse.fromJson(element)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<List<CurrencyResponse>> getCurrencyByDate(String date) async {
    try {
      final response = await dio.get('arkhiv-kursov-valyut/json/all/$date/');
      return (response.data as List).map((element) => CurrencyResponse.fromJson(element)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<List<CurrencyResponse>> getCurrencyByCodeAndDate(String ccy, String date) async {
    try {
      final response = await dio.get('arkhiv-kursov-valyut/json/$ccy/$date/');
      return (response.data as List).map((element) => CurrencyResponse.fromJson(element)).toList();
    } on DioException {
      rethrow;
    }
  }
}
