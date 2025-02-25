class CurrencyModelSqfLite {
  final int? id;
  final String ccy;

  CurrencyModelSqfLite({this.id, required this.ccy});

  factory CurrencyModelSqfLite.fromJson(Map<String, dynamic> json) => CurrencyModelSqfLite(id: json['id'], ccy: json['ccy']);

  Map<String, dynamic> toJson() => {'id': id, 'ccy': ccy};
}
