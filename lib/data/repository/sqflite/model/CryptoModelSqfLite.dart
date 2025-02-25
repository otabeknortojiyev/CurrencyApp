class CryptoModelSqfLite {
  final int? id;
  final String cryptoId;

  CryptoModelSqfLite({this.id, required this.cryptoId});

  factory CryptoModelSqfLite.fromJson(Map<String, dynamic> json) => CryptoModelSqfLite(id: json['id'], cryptoId: json['cryptoId']);

  Map<String, dynamic> toJson() => {'id': id, 'cryptoId': cryptoId};
}
