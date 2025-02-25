import '../../../data/source/remote/response/crypto_response_by_id.dart';
import '../../../data/source/remote/response/currency_response.dart';
import '../currency_page/state.dart';

class FavoritePageState {
  //currency
  FavoriteCurrencyPageStatus? currencyStatus;
  LanguageStatus? langStatus = LanguageStatus.rus;
  List<CurrencyResponse>? currencyData;
  String? currencyErrorMessage;
  double? converted;
  String? firstCurrency;
  String? secondCurrency;

  //crypto
  FavoriteCryptoPageStatus? cryptoStatus;
  List<CryptoResponseById>? cryptoData;
  String? cryptoErrorMessage;

  FavoritePageState({
    this.currencyStatus,
    this.currencyData,
    this.currencyErrorMessage,
    this.converted = 0.0,
    this.firstCurrency,
    this.secondCurrency,
    this.langStatus,
    this.cryptoStatus,
    this.cryptoData,
    this.cryptoErrorMessage,
  });

  FavoritePageState copyWith({
    FavoriteCurrencyPageStatus? currencyStatus,
    LanguageStatus? langStatus,
    List<CurrencyResponse>? currencyData,
    String? currencyErrorMessage,
    double? converted,
    String? firstCurrency,
    String? secondCurrency,
    FavoriteCryptoPageStatus? cryptoStatus,
    List<CryptoResponseById>? cryptoData,
    String? cryptoErrorMessage,
  }) => FavoritePageState(
    currencyStatus: currencyStatus ?? this.currencyStatus,
    langStatus: langStatus ?? this.langStatus,
    currencyData: currencyData ?? this.currencyData,
    currencyErrorMessage: currencyErrorMessage ?? this.currencyErrorMessage,
    converted: converted ?? 0.0,
    firstCurrency: firstCurrency ?? this.firstCurrency,
    secondCurrency: secondCurrency ?? this.secondCurrency,
    cryptoStatus: cryptoStatus ?? this.cryptoStatus,
    cryptoData: cryptoData ?? this.cryptoData,
    cryptoErrorMessage: cryptoErrorMessage ?? this.cryptoErrorMessage,
  );
}

enum FavoriteCurrencyPageStatus { initial, loading, success, fail }

enum FavoriteCryptoPageStatus { initial, loading, success, fail }
