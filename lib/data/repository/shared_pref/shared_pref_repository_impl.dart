import 'package:currency_app/data/repository/shared_pref/shared_pref_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../presentation/main_screen/currency_page/state.dart';

class SharedPrefRepositoryImpl implements SharedPrefRepository {
  static final SharedPrefRepositoryImpl _instance = SharedPrefRepositoryImpl._internal();
  static const key = "Lang";

  SharedPrefRepositoryImpl._internal();

  factory SharedPrefRepositoryImpl() {
    return _instance;
  }

  @override
  Future<void> setLanguage(LanguageStatus lang) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key, lang.name);
  }

  @override
  Future<LanguageStatus> getLanguage() async {
    final pref = await SharedPreferences.getInstance();
    final languageName = pref.getString(key);
    if (languageName != null) {
      return LanguageStatus.values.firstWhere((status) => status.name == languageName, orElse: () => LanguageStatus.rus);
    }
    return LanguageStatus.kiril;
  }
}
