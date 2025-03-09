abstract class CryptoPageEvent {}

class GetCryptoEvent extends CryptoPageEvent {
  final int start;

  GetCryptoEvent({required this.start});
}

class SearchCryptoEvent extends CryptoPageEvent {
  final String name;

  SearchCryptoEvent({required this.name});
}

class AddCryptoToFavoriteEvent extends CryptoPageEvent {
  final String cryptoId;

  AddCryptoToFavoriteEvent({required this.cryptoId});
}

class DoNotShowCaseViewEvent extends CryptoPageEvent {}
