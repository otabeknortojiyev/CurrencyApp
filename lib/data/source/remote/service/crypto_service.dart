import 'package:currency_app/data/source/remote/response/crypto_response.dart';
import 'package:dio/dio.dart';

import '../response/crypto_response_by_id.dart';

class CryptoService {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.coinlore.net/api/',
      contentType: 'application/json',
      receiveTimeout: Duration(seconds: 30),
      connectTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 30),
      receiveDataWhenStatusError: true,
    ),
  );

  Future<CryptoResponse?> getCrypto(int start) async {
    try {
      final response = await dio.get('tickers/?start=${start * 100}&limit=100');
      if (response.statusCode == 200) {
        return CryptoResponse.fromJson(response.data);
      } else {
        throw Exception("Ошибка: ${response.statusCode}");
      }
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<CryptoResponseById>?> getCryptoById(List<String> ids) async {
    try {
      final idString = ids.join(',');
      final response = await dio.get('ticker/?id=$idString');
      if (response.statusCode == 200) {
        return (response.data as List).map((element) => CryptoResponseById.fromJson(element)).toList();
      } else {
        throw Exception("Ошибка: ${response.statusCode}");
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
