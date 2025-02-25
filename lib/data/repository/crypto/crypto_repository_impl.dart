import 'package:currency_app/data/repository/crypto/crypto_repository.dart';
import 'package:currency_app/data/source/remote/response/crypto_response.dart';
import 'package:currency_app/data/source/remote/service/crypto_service.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final service = CryptoService();

  @override
  Future<CryptoResponse?> getCrypto(int start) async {
    return await service.getCrypto(start);
  }
}
