class CryptoResponse {
  List<Crypto>? list;
  Info? info;

  CryptoResponse({this.list, this.info});

  CryptoResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      list = <Crypto>[];
      json['data'].forEach((v) {
        list!.add(new Crypto.fromJson(v));
      });
    }
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['data'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Crypto {
  String? id; // ID of cryptocurrency
  String? symbol; // Cryptocurrency Ticker symbol
  String? name; // Full name of crypto coin
  String? nameid; // Name slug
  int? rank; // Rank by marketcap
  String? priceUsd; // Price in USD currency
  String? percentChange24h; // Price change in percent for last 24h
  String? percentChange1h; // Price change in percent for last 1h
  String? percentChange7d; // Price change in percent for last 7 days
  String? priceBtc; // How much coin costs in BTC
  String? marketCapUsd; // Coin marketcap in USD
  double? volume24; // Trading volume of coin for last 24h in USD
  double? volume24a; // How many coins has been traded
  String? csupply; // Circulating Supply
  String? tsupply; // Total Supply
  String? msupply; // Maximum Supply

  Crypto({
    this.id,
    this.symbol,
    this.name,
    this.nameid,
    this.rank,
    this.priceUsd,
    this.percentChange24h,
    this.percentChange1h,
    this.percentChange7d,
    this.priceBtc,
    this.marketCapUsd,
    this.volume24,
    this.volume24a,
    this.csupply,
    this.tsupply,
    this.msupply,
  });

  Crypto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symbol = json['symbol'];
    name = json['name'];
    nameid = json['nameid'];
    rank = json['rank'];
    priceUsd = json['price_usd'];
    percentChange24h = json['percent_change_24h'];
    percentChange1h = json['percent_change_1h'];
    percentChange7d = json['percent_change_7d'];
    priceBtc = json['price_btc'];
    marketCapUsd = json['market_cap_usd'];
    volume24 = json['volume24'];
    volume24a = json['volume24a'];
    csupply = json['csupply'];
    tsupply = json['tsupply'];
    msupply = json['msupply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    data['nameid'] = this.nameid;
    data['rank'] = this.rank;
    data['price_usd'] = this.priceUsd;
    data['percent_change_24h'] = this.percentChange24h;
    data['percent_change_1h'] = this.percentChange1h;
    data['percent_change_7d'] = this.percentChange7d;
    data['price_btc'] = this.priceBtc;
    data['market_cap_usd'] = this.marketCapUsd;
    data['volume24'] = this.volume24;
    data['volume24a'] = this.volume24a;
    data['csupply'] = this.csupply;
    data['tsupply'] = this.tsupply;
    data['msupply'] = this.msupply;
    return data;
  }
}

class Info {
  int? coinsNum; // Total available coins, can be used to loop through all coins as maximum limit of tickers endpoint is 100 coins.
  int? time; // Timestamp

  Info({this.coinsNum, this.time});

  Info.fromJson(Map<String, dynamic> json) {
    coinsNum = json['coins_num'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins_num'] = this.coinsNum;
    data['time'] = this.time;
    return data;
  }
}
