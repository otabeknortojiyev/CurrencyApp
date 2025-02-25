import 'package:currency_app/presentation/main_screen/currency_page/state.dart';

abstract class CurrencyPageEvent {}

class GetCurrencyEvent extends CurrencyPageEvent {}

class GetCurrencyByDateEvent extends CurrencyPageEvent {
  final String date;

  GetCurrencyByDateEvent({required this.date});
}

class ChangeLanguageEvent extends CurrencyPageEvent {
  final LanguageStatus status;

  ChangeLanguageEvent({required this.status});
}

class ConvertEvent extends CurrencyPageEvent {
  final double converted;

  ConvertEvent({required this.converted});
}

class ChangeConvertEvent extends CurrencyPageEvent {
  final String firstCurrency;
  final String secondCurrency;

  ChangeConvertEvent({required this.firstCurrency, required this.secondCurrency});
}

class AddCurrencyToFavoriteEvent extends CurrencyPageEvent {
  final String ccy;

  AddCurrencyToFavoriteEvent({required this.ccy});
}
