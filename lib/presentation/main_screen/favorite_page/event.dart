abstract class FavoritePageEvent {}

class GetFavoriteCurrencyEvent extends FavoritePageEvent {
  final String date;

  GetFavoriteCurrencyEvent({required this.date});
}

class ConvertFavoriteCurrencyEvent extends FavoritePageEvent {
  final double converted;

  ConvertFavoriteCurrencyEvent({required this.converted});
}

class ChangeFavoriteConvertEvent extends FavoritePageEvent {
  final String firstCurrency;
  final String secondCurrency;

  ChangeFavoriteConvertEvent({required this.firstCurrency, required this.secondCurrency});
}

class DeleteFavoriteCurrencyEvent extends FavoritePageEvent {
  final String ccy;

  DeleteFavoriteCurrencyEvent({required this.ccy});
}

class GetFavoriteCryptoEvent extends FavoritePageEvent {}

class DeleteFavoriteCryptoEvent extends FavoritePageEvent {
  final String cryptoId;

  DeleteFavoriteCryptoEvent({required this.cryptoId});
}
