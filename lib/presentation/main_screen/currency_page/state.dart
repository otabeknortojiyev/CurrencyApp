import 'dart:ffi';

import '../../../data/source/remote/response/currency_response.dart';

class CurrencyPageState {
  CurrencyPageStatus? status;
  LanguageStatus? langStatus = LanguageStatus.rus;
  List<CurrencyResponse>? data;
  String? errorMessage;
  double? converted;
  String? firstCurrency;
  String? secondCurrency;
  bool? showCaseView;

  CurrencyPageState({
    this.status,
    this.langStatus,
    this.data,
    this.errorMessage,
    this.converted = 0.0,
    this.firstCurrency,
    this.secondCurrency,
    this.showCaseView,
  });

  CurrencyPageState copyWith({
    CurrencyPageStatus? status,
    LanguageStatus? langStatus,
    List<CurrencyResponse>? data,
    String? errorMessage,
    double? converted,
    String? firstCurrency,
    String? secondCurrency,
    bool? showCaseView,
  }) => CurrencyPageState(
    status: status ?? this.status,
    langStatus: langStatus ?? this.langStatus,
    data: data ?? this.data,
    errorMessage: errorMessage ?? this.errorMessage,
    converted: converted ?? 0.0,
    firstCurrency: firstCurrency ?? this.firstCurrency,
    secondCurrency: secondCurrency ?? this.secondCurrency,
    showCaseView: showCaseView,
  );
}

enum CurrencyPageStatus { initial, loading, success, fail }

enum LanguageStatus { rus, uz, kiril, eng }
