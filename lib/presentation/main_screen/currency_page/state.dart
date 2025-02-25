import '../../../data/source/remote/response/currency_response.dart';

class CurrencyPageState {
  CurrencyPageStatus? status;
  LanguageStatus? langStatus = LanguageStatus.rus;
  List<CurrencyResponse>? data;
  String? errorMessage;
  double? converted;
  String? firstCurrency;
  String? secondCurrency;

  CurrencyPageState({this.status, this.langStatus, this.data, this.errorMessage, this.converted = 0.0, this.firstCurrency, this.secondCurrency});

  CurrencyPageState copyWith({
    CurrencyPageStatus? status,
    LanguageStatus? langStatus,
    List<CurrencyResponse>? data,
    String? errorMessage,
    double? converted,
    String? firstCurrency,
    String? secondCurrency,
  }) => CurrencyPageState(
    status: status ?? this.status,
    langStatus: langStatus ?? this.langStatus,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
    converted: converted ?? 0.0,
    firstCurrency: firstCurrency ?? this.firstCurrency,
    secondCurrency: secondCurrency ?? this.secondCurrency,
  );
}

enum CurrencyPageStatus { initial, loading, success, fail }

enum LanguageStatus { rus, uz, kiril, eng }

