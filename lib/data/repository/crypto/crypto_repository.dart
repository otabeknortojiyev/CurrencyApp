import '../../source/remote/response/crypto_response.dart';

abstract class CryptoRepository {
  Future<CryptoResponse?> getCrypto(int start);
}
