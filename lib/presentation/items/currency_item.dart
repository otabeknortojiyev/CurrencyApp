import 'package:currency_app/data/source/remote/response/currency_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/utils.dart';
import '../main_screen/currency_page/state.dart';

class CurrencyItem extends StatefulWidget {
  final LanguageStatus lang;
  final CurrencyResponse currency;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final VoidCallback onTapConvert;
  final bool isExpanded;

  const CurrencyItem({
    super.key,
    required this.currency,
    required this.onTap,
    required this.onDoubleTap,
    required this.lang,
    required this.isExpanded,
    required this.onTapConvert,
  });

  @override
  State<CurrencyItem> createState() => _CurrencyItemState();
}

class _CurrencyItemState extends State<CurrencyItem> with SingleTickerProviderStateMixin {
  var calculateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String? countryCode = getCountryCodeFromCurrency(widget.currency.ccy!);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, offset: Offset(2, 4), spreadRadius: 1)],
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade100], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: () {
                      widget.onDoubleTap();
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (countryCode != null)
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: Offset(1, 2))],
                                  ),
                                  child: Image.network(
                                    getFlagUrl(countryCode),
                                    width: 24,
                                    height: 24,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.flag, size: 24, color: Colors.grey.shade600);
                                    },
                                  ),
                                ),
                              if (countryCode == null) Icon(Icons.flag, size: 24, color: Colors.grey.shade600),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  widget.lang == LanguageStatus.rus
                                      ? widget.currency.ccyNmRU!
                                      : widget.lang == LanguageStatus.kiril
                                      ? widget.currency.ccyNmUZC!
                                      : widget.lang == LanguageStatus.uz
                                      ? widget.currency.ccyNmUZ!
                                      : widget.currency.ccyNmEN!,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                widget.currency.diff!.isNotEmpty && widget.currency.diff![0] == '-'
                                    ? widget.currency.diff!
                                    : '+${widget.currency.diff}',
                                style: TextStyle(
                                  color: widget.currency.diff!.isNotEmpty && widget.currency.diff![0] == '-' ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '1 ${widget.currency.ccy} => ${formatRate(widget.currency.rate!)} UZS  |  ',
                                style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              SvgPicture.asset('assets/calendar.svg', width: 20, height: 20),
                              SizedBox(width: 5),
                              Text(
                                widget.currency.date!,
                                style: TextStyle(color: CupertinoColors.systemGrey.resolveFrom(context), fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.onTap();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child:
                          widget.isExpanded
                              ? SvgPicture.asset('assets/up.svg', width: 24, height: 24, color: Colors.blue.shade800, key: ValueKey('up'))
                              : SvgPicture.asset('assets/down.svg', width: 24, height: 24, color: Colors.blue.shade800, key: ValueKey('down')),
                    ),
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              child: AnimatedOpacity(
                opacity: widget.isExpanded ? 1 : 0,
                duration: Duration(milliseconds: 300),
                curve: Curves.decelerate,
                child:
                    widget.isExpanded
                        ? Padding(
                          key: calculateKey,
                          padding: const EdgeInsets.only(bottom: 16, right: 16),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.blue.shade800),
                              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            ),
                            onPressed: () {
                              widget.onTapConvert();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset('assets/calculator.svg', width: 24, height: 24),
                                SizedBox(width: 10),
                                Text("Calculate", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )
                        : SizedBox(width: 160),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getFlagUrl(String countryCode) {
  return "https://flagcdn.com/w320/${countryCode.toLowerCase()}.png";
}

String? getCountryCodeFromCurrency(String currencyCode) {
  return currencyToCountry[currencyCode];
}

Map<String, String> currencyToCountry = {
  "AED": "AE",
  "AFN": "AF",
  "ALL": "AL",
  "AMD": "AM",
  "ANG": "NL",
  "AOA": "AO",
  "ARS": "AR",
  "AUD": "AU",
  "AWG": "AW",
  "AZN": "AZ",
  "BAM": "BA",
  "BBD": "BB",
  "BDT": "BD",
  "BGN": "BG",
  "BHD": "BH",
  "BIF": "BI",
  "BMD": "BM",
  "BND": "BN",
  "BOB": "BO",
  "BRL": "BR",
  "BSD": "BS",
  "BTN": "BT",
  "BWP": "BW",
  "BYN": "BY",
  "BZD": "BZ",
  "CAD": "CA",
  "CDF": "CD",
  "CHF": "CH",
  "CLP": "CL",
  "CNY": "CN",
  "COP": "CO",
  "CRC": "CR",
  "CUP": "CU",
  "CVE": "CV",
  "CZK": "CZ",
  "DJF": "DJ",
  "DKK": "DK",
  "DOP": "DO",
  "DZD": "DZ",
  "EGP": "EG",
  "ERN": "ER",
  "ETB": "ET",
  "EUR": "DE",
  "FJD": "FJ",
  "FKP": "FK",
  "FOK": "FO",
  "GBP": "GB",
  "GEL": "GE",
  "GGP": "GG",
  "GHS": "GH",
  "GIP": "GI",
  "GMD": "GM",
  "GNF": "GN",
  "GTQ": "GT",
  "GYD": "GY",
  "HKD": "HK",
  "HNL": "HN",
  "HRK": "HR",
  "HTG": "HT",
  "HUF": "HU",
  "IDR": "ID",
  "ILS": "IL",
  "IMP": "IM",
  "INR": "IN",
  "IQD": "IQ",
  "IRR": "IR",
  "ISK": "IS",
  "JEP": "JE",
  "JMD": "JM",
  "JOD": "JO",
  "JPY": "JP",
  "KES": "KE",
  "KGS": "KG",
  "KHR": "KH",
  "KID": "KI",
  "KMF": "KM",
  "KRW": "KR",
  "KWD": "KW",
  "KYD": "KY",
  "KZT": "KZ",
  "LAK": "LA",
  "LBP": "LB",
  "LKR": "LK",
  "LRD": "LR",
  "LSL": "LS",
  "LYD": "LY",
  "MAD": "MA",
  "MDL": "MD",
  "MGA": "MG",
  "MKD": "MK",
  "MMK": "MM",
  "MNT": "MN",
  "MOP": "MO",
  "MRU": "MR",
  "MUR": "MU",
  "MVR": "MV",
  "MWK": "MW",
  "MXN": "MX",
  "MYR": "MY",
  "MZN": "MZ",
  "NAD": "NA",
  "NGN": "NG",
  "NIO": "NI",
  "NOK": "NO",
  "NPR": "NP",
  "NZD": "NZ",
  "OMR": "OM",
  "PAB": "PA",
  "PEN": "PE",
  "PGK": "PG",
  "PHP": "PH",
  "PKR": "PK",
  "PLN": "PL",
  "PYG": "PY",
  "QAR": "QA",
  "RON": "RO",
  "RSD": "RS",
  "RUB": "RU",
  "RWF": "RW",
  "SAR": "SA",
  "SBD": "SB",
  "SCR": "SC",
  "SDG": "SD",
  "SEK": "SE",
  "SGD": "SG",
  "SHP": "SH",
  "SLE": "SL",
  "SOS": "SO",
  "SRD": "SR",
  "SSP": "SS",
  "STN": "ST",
  "SYP": "SY",
  "SZL": "SZ",
  "THB": "TH",
  "TJS": "TJ",
  "TMT": "TM",
  "TND": "TN",
  "TOP": "TO",
  "TRY": "TR",
  "TTD": "TT",
  "TVD": "TV",
  "TZS": "TZ",
  "UAH": "UA",
  "UGX": "UG",
  "USD": "US",
  "UYU": "UY",
  "UZS": "UZ",
  "VES": "VE",
  "VND": "VN",
  "VUV": "VU",
  "WST": "WS",
  "XAF": "CM",
  "XCD": "AG",
  "XOF": "SN",
  "XPF": "PF",
  "YER": "YE",
  "ZAR": "ZA",
  "ZMW": "ZM",
  "ZWL": "ZW",
};
