import 'package:currency_app/data/repository/shared_pref/shared_pref_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../presentation/main_screen/currency_page/state.dart';

class SharedPrefRepositoryImpl implements SharedPrefRepository {
  static final SharedPrefRepositoryImpl _instance = SharedPrefRepositoryImpl._internal();
  static const key1 = "Lang";
  static const key2 = "CurrencyShowCaseView";
  static const key3 = "CryptoShowCaseView";

  SharedPrefRepositoryImpl._internal();

  factory SharedPrefRepositoryImpl() {
    return _instance;
  }

  @override
  Future<void> setLanguage(LanguageStatus lang) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key1, lang.name);
  }

  @override
  Future<LanguageStatus> getLanguage() async {
    final pref = await SharedPreferences.getInstance();
    final languageName = pref.getString(key1);
    if (languageName != null) {
      return LanguageStatus.values.firstWhere((status) => status.name == languageName, orElse: () => LanguageStatus.rus);
    }
    return LanguageStatus.kiril;
  }

  @override
  Future<void> setCurrencyShowCaseView() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(key2, true);
  }

  @override
  Future<bool> getCurrencyShowCaseView() async {
    final pref = await SharedPreferences.getInstance();
    final showCaseView = pref.getBool(key2) ?? false;
    return showCaseView;
  }

  @override
  Future<void> setCryptoShowCaseView() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(key3, true);
  }

  @override
  Future<bool> getCryptoShowCaseView() async {
    final pref = await SharedPreferences.getInstance();
    final showCaseView = pref.getBool(key3) ?? false;
    return showCaseView;
  }
}
