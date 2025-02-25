import '../../../presentation/main_screen/currency_page/state.dart';

abstract class SharedPrefRepository {
  Future<LanguageStatus?> getLanguage();

  Future<void> setLanguage(LanguageStatus lang);
}
