import 'package:currency_app/data/source/remote/response/crypto_response.dart';

class CryptoPageState {
  CryptoPageStatus? status;
  CryptoResponse? data;
  String? errorMessage;
  List<Crypto>? list;

  CryptoPageState({this.status, this.data, this.errorMessage, this.list});

  CryptoPageState copyWith({CryptoPageStatus? status, CryptoResponse? data, String? errorMessage, List<Crypto>? list}) => CryptoPageState(
    status: status ?? this.status,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
    list: list ?? this.list,
  );
}

enum CryptoPageStatus { initial, loading, success, fail }
