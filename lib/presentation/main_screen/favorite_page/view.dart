import 'package:currency_app/data/source/remote/response/crypto_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:motion/motion.dart';

import '../../../data/source/remote/response/currency_response.dart';
import '../../../utils/utils.dart';
import '../../items/crypto_item.dart';
import '../../items/currency_item.dart';
import '../currency_page/state.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class FavoritePage extends StatefulWidget {
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;
  int selectedIndex = -1;
  final VoidCallback popFromCurrency;
  final VoidCallback popFromCrypto;

  FavoritePage({super.key, required this.onScrollNotification, required this.popFromCurrency, required this.popFromCrypto});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int openedItemIndex = -1;
  late CurrencyResponse currency;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FavoritePageBloc(),
      child: BlocListener<FavoritePageBloc, FavoritePageState>(
        listener: (context, state) {},
        child: Builder(builder: (context) => _buildPage(context)),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<FavoritePageBloc>(context);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime now = DateTime.now();
    int currentTimeInSeconds = now.millisecondsSinceEpoch ~/ 1000;
    bloc.add(GetFavoriteCurrencyEvent(date: today));
    bloc.add(GetFavoriteCryptoEvent());
    return NotificationListener<ScrollNotification>(
      onNotification: widget.onScrollNotification,
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 30),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)), color: Colors.blue),
              child: AppBar(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
                backgroundColor: Colors.transparent,
                title: Text("Favorite"),
                centerTitle: true,
                titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                actionsPadding: EdgeInsets.only(right: 16),
                bottom: TabBar(
                  tabs: [Tab(icon: Icon(Icons.currency_exchange, color: Colors.white)), Tab(icon: Icon(Icons.currency_bitcoin, color: Colors.white))],
                  indicatorColor: Colors.transparent,
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  dividerColor: Colors.transparent,
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              BlocBuilder<FavoritePageBloc, FavoritePageState>(
                builder: (context, state) {
                  if (state.currencyStatus == FavoriteCurrencyPageStatus.loading) {
                    return Center(child: CupertinoActivityIndicator(radius: 15));
                  } else if (state.currencyStatus == FavoriteCurrencyPageStatus.success) {
                    if (state.currencyData!.isEmpty) {
                      return Center(
                        child: Motion(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 5, blurRadius: 16, offset: const Offset(0, 10)),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                  child: Icon(LucideIcons.wallet2, size: 60, color: Colors.grey.shade400),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Нет добавленных валют',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Добавьте валюты в избранное,\nчтобы отслеживать курс здесь.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () {
                                    widget.popFromCurrency();
                                  },
                                  child: const Text('Добавить валюту', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: ListView.builder(
                          itemCount: state.currencyData?.length,
                          itemBuilder: (context, index) {
                            return CurrencyItem(
                              currency: state.currencyData![index],
                              onTap: () {
                                if (widget.selectedIndex == index) {
                                  widget.selectedIndex = -1;
                                } else {
                                  widget.selectedIndex = index;
                                }
                                setState(() {});
                              },
                              lang: state.langStatus!,
                              isExpanded: widget.selectedIndex == index,
                              onTapConvert: () {
                                bloc.add(ConvertFavoriteCurrencyEvent(converted: 0.0));
                                bloc.add(ChangeFavoriteConvertEvent(firstCurrency: 'UZS', secondCurrency: state.currencyData![index].ccy!));
                                currency = state.currencyData![index];
                                _showExchangeModalBottomSheet(context);
                              },
                              onDoubleTap: () {
                                bloc.add(DeleteFavoriteCurrencyEvent(ccy: state.currencyData![index].ccy!));
                              },
                            );
                          },
                        ),
                      );
                    }
                  } else if (state.currencyStatus == CurrencyPageStatus.fail) {
                    Center(child: Text(state.currencyErrorMessage ?? 'Unknown Error'));
                  }
                  return Center();
                },
              ),
              BlocBuilder<FavoritePageBloc, FavoritePageState>(
                builder: (context, state) {
                  if (state.cryptoStatus == FavoriteCryptoPageStatus.loading) {
                    return Center(child: CupertinoActivityIndicator(radius: 15));
                  } else if (state.cryptoStatus == FavoriteCryptoPageStatus.success) {
                    if (state.cryptoData!.isEmpty) {
                      return Center(
                        child: Motion(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 5, blurRadius: 16, offset: const Offset(0, 10)),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                                  child: Icon(LucideIcons.bitcoin, size: 60, color: Colors.orange.shade400),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  textAlign: TextAlign.center,
                                  'Нет добавленных\nкриптовалют',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Добавьте криптовалюты в избранное,\nчтобы отслеживать их курс здесь.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () {
                                    widget.popFromCrypto();
                                  },
                                  child: const Text('Добавить криптовалюту', style: TextStyle(color: Colors.white, fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: state.cryptoData!.length,
                        itemBuilder: (context, index) {
                          return CryptoItem(
                            crypto: Crypto(
                              id: state.cryptoData![index].id,
                              symbol: state.cryptoData![index].symbol,
                              name: state.cryptoData![index].name,
                              nameid: state.cryptoData![index].nameid,
                              rank: state.cryptoData![index].rank,
                              priceUsd: state.cryptoData![index].priceUsd,
                              percentChange24h: state.cryptoData![index].percentChange24h,
                              percentChange1h: state.cryptoData![index].percentChange1h,
                              percentChange7d: state.cryptoData![index].percentChange7d,
                              priceBtc: state.cryptoData![index].priceBtc,
                              marketCapUsd: state.cryptoData![index].marketCapUsd,
                              volume24: state.cryptoData![index].volume24,
                              volume24a: state.cryptoData![index].volume24a,
                              csupply: state.cryptoData![index].csupply,
                              tsupply: state.cryptoData![index].tsupply,
                              msupply: state.cryptoData![index].msupply,
                            ),
                            time: currentTimeInSeconds,
                            onDoubleTap: () {
                              bloc.add(DeleteFavoriteCryptoEvent(cryptoId: state.cryptoData![index].id!));
                            },
                          );
                        },
                      );
                    }
                  } else if (state.cryptoStatus == FavoriteCryptoPageStatus.fail) {
                    return Center(child: Text(state.cryptoErrorMessage ?? 'Unknown Error'));
                  }
                  return Center();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExchangeModalBottomSheet(BuildContext context) {
    final bloc = BlocProvider.of<FavoritePageBloc>(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      backgroundColor: Colors.white,
      builder: (context) {
        var controller1 = TextEditingController();
        var firstCurrency = 'UZS';
        var secondCurrency = currency.ccy;
        return BlocProvider.value(
          value: bloc,
          child: StatefulBuilder(
            builder: (context, setState) {
              late AnimationController rotationController = AnimationController(
                duration: const Duration(milliseconds: 300),
                vsync: Navigator.of(context),
              );
              void rotateIcon() {
                if (rotationController.isCompleted) {
                  rotationController.reverse();
                } else {
                  rotationController.forward();
                }
                bloc.add(ChangeFavoriteConvertEvent(firstCurrency: secondCurrency!, secondCurrency: firstCurrency));
                bloc.add(ConvertFavoriteCurrencyEvent(converted: 0.0));
                controller1.clear();
              }

              return AnimatedPadding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      Text("Конвертация валют", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                      const SizedBox(height: 20),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.blue.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            BlocBuilder<FavoritePageBloc, FavoritePageState>(
                              builder: (context, state) {
                                firstCurrency = state.firstCurrency!;
                                return Expanded(
                                  child: Text(
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    '${NumberFormat("#,##0.00", "en_US").format(state.converted).replaceAll(",", " ")} ${state.firstCurrency}',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
                                  ),
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: rotateIcon,
                              child: AnimatedBuilder(
                                animation: rotationController,
                                builder: (context, child) {
                                  return Transform.rotate(angle: rotationController.value * 3.14, child: child);
                                },
                                child: SvgPicture.asset('assets/exchange.svg', width: 28, height: 28),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<FavoritePageBloc, FavoritePageState>(
                        builder: (context, state) {
                          secondCurrency = state.secondCurrency;
                          return TextField(
                            cursorWidth: 1,
                            cursorColor: Colors.grey.shade600,
                            controller: controller1,
                            keyboardType: TextInputType.number,
                            inputFormatters: [ThousandsSeparatorInputFormatter()],
                            decoration: InputDecoration(
                              labelText: state.secondCurrency,
                              labelStyle: TextStyle(color: Colors.grey.shade600),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                            onChanged: (value) {
                              String numericValue = value.replaceAll(' ', '');
                              double? inputValue = double.tryParse(numericValue);
                              double? rate = double.tryParse(currency.rate!.replaceAll(',', '.'));
                              if (inputValue != null && rate != null) {
                                double converted;
                                if (firstCurrency != 'UZS') {
                                  converted = inputValue / rate;
                                } else {
                                  converted = inputValue * rate;
                                }
                                bloc.add(ConvertFavoriteCurrencyEvent(converted: converted));
                              } else if (inputValue == null) {
                                bloc.add(ConvertFavoriteCurrencyEvent(converted: 0.0));
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
