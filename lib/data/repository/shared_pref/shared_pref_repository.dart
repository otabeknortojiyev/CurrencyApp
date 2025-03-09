import '../../../presentation/main_screen/currency_page/state.dart';

abstract class SharedPrefRepository {
  Future<LanguageStatus?> getLanguage();

  Future<void> setLanguage(LanguageStatus lang);

  Future<void> setCurrencyShowCaseView();

  Future<bool> getCurrencyShowCaseView();

  Future<void> setCryptoShowCaseView();

  Future<bool> getCryptoShowCaseView();
}
