class CurrencyResponse {
  int? id; // Tartib raqami;
  String? code; //  Valyutaning sonli kodi. Masalan: 840, 978, 643 va boshqalar;
  String? ccy; // Valyutaning ramzli kodi (alfa-3). Masalan: USD, EUR, RUB va boshqalar;
  String? ccyNmRU; // Valyutaning rus tilidagi nomi;
  String? ccyNmUZ; // Valyutaning o‘zbek (lotin) tilidagi nomi;
  String? ccyNmUZC; // Valyutaning o‘zbek (kirillitsa) tilidagi nomi;
  String? ccyNmEN; // Valyutaning ingliz tilidagi nomi;
  String? nominal; // Valyutaning birliklar soni;
  String? rate; // Valyuta kursi;
  String? diff; // Valyutlar kurslari farqi;
  String? date; // Kursning amal qilish sanasi.

  CurrencyResponse({
    this.id,
    this.code,
    this.ccy,
    this.ccyNmRU,
    this.ccyNmUZ,
    this.ccyNmUZC,
    this.ccyNmEN,
    this.nominal,
    this.rate,
    this.diff,
    this.date,
  });

  CurrencyResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['Code'];
    ccy = json['Ccy'];
    ccyNmRU = json['CcyNm_RU'];
    ccyNmUZ = json['CcyNm_UZ'];
    ccyNmUZC = json['CcyNm_UZC'];
    ccyNmEN = json['CcyNm_EN'];
    nominal = json['Nominal'];
    rate = json['Rate'];
    diff = json['Diff'];
    date = json['Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Code'] = this.code;
    data['Ccy'] = this.ccy;
    data['CcyNm_RU'] = this.ccyNmRU;
    data['CcyNm_UZ'] = this.ccyNmUZ;
    data['CcyNm_UZC'] = this.ccyNmUZC;
    data['CcyNm_EN'] = this.ccyNmEN;
    data['Nominal'] = this.nominal;
    data['Rate'] = this.rate;
    data['Diff'] = this.diff;
    data['Date'] = this.date;
    return data;
  }
}
