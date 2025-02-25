import 'package:currency_app/data/source/remote/response/crypto_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../utils/utils.dart';

class CryptoItem extends StatefulWidget {
  final Crypto crypto;
  final int time;
  final VoidCallback onDoubleTap;

  const CryptoItem({super.key, required this.crypto, required this.time, required this.onDoubleTap});

  @override
  State<CryptoItem> createState() => _CryptoItemState();
}

class _CryptoItemState extends State<CryptoItem> with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(widget.time * 1000);
    String formattedDate = DateFormat('dd.MM.yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.2), blurRadius: 5, offset: Offset(1, 2), spreadRadius: 1)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: () {
                widget.onDoubleTap();
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Image.network(
                              'https://assets.coincap.io/assets/icons/${widget.crypto.symbol!.toLowerCase()}@2x.png',
                              width: 36,
                              height: 36,
                              errorBuilder: (context, error, stackTrace) {
                                return SvgPicture.asset('assets/coin1.svg', width: 36, height: 36);
                              },
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.crypto.name!,
                                style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontWeight: FontWeight.w700, fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildPercentageRow('1h', widget.crypto.percentChange1h!),
                          SizedBox(height: 6),
                          _buildPercentageRow('24h', widget.crypto.percentChange24h!),
                          SizedBox(height: 6),
                          _buildPercentageRow('7d', widget.crypto.percentChange7d!),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(CupertinoIcons.calendar, size: 20, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                      SizedBox(width: 5),
                      Text(
                        formattedDate,
                        style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '1 ${widget.crypto.symbol} => ${widget.crypto.priceUsd} \$',
                        style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                color: Colors.white,
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                      size: 20,
                      color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    ),
                    SizedBox(width: 5),
                    Text(
                      isExpanded ? 'Less' : 'More',
                      style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isExpanded) ...[
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '1 ${widget.crypto.symbol} ',
                            style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: '=> ${widget.crypto.priceBtc} BTC',
                            style: TextStyle(color: CupertinoColors.systemGreen, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(
                      icon: CupertinoIcons.money_dollar_circle,
                      label: 'Market capitalization: ',
                      value: '${formatNumber(widget.crypto.marketCapUsd!)} \$',
                      color: CupertinoColors.systemGreen,
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(
                      icon: CupertinoIcons.chart_bar_alt_fill,
                      label: 'Trading volume for 24h: ',
                      value: formatNumberDouble(widget.crypto.volume24!),
                      color: CupertinoColors.systemPurple,
                    ),
                    SizedBox(height: 10),
                    _buildInfoRow(
                      icon: CupertinoIcons.bitcoin_circle,
                      label: 'Coins traded for 24h: ',
                      value: formatNumberDouble(widget.crypto.volume24a!),
                      color: CupertinoColors.systemBlue,
                    ),
                    SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value, required Color color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        SizedBox(width: 5),
        Text(label, style: TextStyle(color: CupertinoColors.label.resolveFrom(context), fontSize: 16, fontWeight: FontWeight.w600)),
        Text(value, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildPercentageRow(String label, String value) {
    final double percent = double.tryParse(value) ?? 0;
    final Color color = percent >= 0 ? CupertinoColors.systemGreen : CupertinoColors.systemRed;

    return Row(
      children: [
        Text('$label: ', style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context), fontSize: 14, fontWeight: FontWeight.w500)),
        Text('${percent.toStringAsFixed(2)}%', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
