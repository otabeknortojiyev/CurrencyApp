import 'dart:async';

import 'package:currency_app/presentation/items/currency_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../data/source/remote/response/currency_response.dart';
import '../../../utils/utils.dart';
import 'bloc.dart';
import 'event.dart';
import 'state.dart';

class CurrencyPage extends StatefulWidget {
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;
  int selectedIndex = -1;
  final VoidCallback addedToFavorite;

  CurrencyPage({super.key, required this.onScrollNotification, required this.addedToFavorite});

  @override
  State<CurrencyPage> createState() => _HomePageState();
}

class _HomePageState extends State<CurrencyPage> with SingleTickerProviderStateMixin {
  late var langStatus;
  int openedItemIndex = -1;
  late CurrencyResponse currency;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CurrencyPageBloc()..add(GetCurrencyEvent()),
      child: BlocListener<CurrencyPageBloc, CurrencyPageState>(
        listener: (context, state) {
          if (state.status == CurrencyPageStatus.fail) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Unknown Error!')));
          }
          if (state.langStatus == LanguageStatus.rus) {
            langStatus = LanguageStatus.rus;
          } else if (state.langStatus == LanguageStatus.uz) {
            langStatus = LanguageStatus.uz;
          } else if (state.langStatus == LanguageStatus.kiril) {
            langStatus = LanguageStatus.kiril;
          } else {
            langStatus = LanguageStatus.eng;
          }
        },
        child: Builder(builder: (context) => _buildPage(context)),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CurrencyPageBloc>(context);
    return NotificationListener<ScrollNotification>(
      onNotification: widget.onScrollNotification,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          backgroundColor: Colors.blue,
          title: Text("Currency"),
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
          actions: [
            GestureDetector(
              onTap: () async {
                final selectedDate = await _showDatePicker(context);
                if (selectedDate != null) {
                  bloc.add(GetCurrencyByDateEvent(date: selectedDate));
                }
              },
              child: SvgPicture.asset('assets/calendar_choose.svg', width: 24, height: 24),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () async {
                var status = await _showModalBottomSheet(context, langStatus);
                if (status != null) {
                  bloc.add(ChangeLanguageEvent(status: status!));
                }
              },
              child: SvgPicture.asset('assets/world.svg', width: 24, height: 24),
            ),
          ],
          actionsPadding: EdgeInsets.only(right: 16),
        ),
        body: BlocBuilder<CurrencyPageBloc, CurrencyPageState>(
          builder: (context, state) {
            if (state.status == CurrencyPageStatus.loading) {
              return Center(child: CupertinoActivityIndicator(radius: 15));
            } else if (state.status == CurrencyPageStatus.success) {
              if (state.data != null) {
                if (state.data!.isEmpty) {
                  return CupertinoActivityIndicator(radius: 15);
                } else {
                  return Center(
                    child: ListView.builder(
                      itemCount: state.data?.length,
                      itemBuilder: (context, index) {
                        return CurrencyItem(
                          currency: state.data![index],
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
                            bloc.add(ConvertEvent(converted: 0.0));
                            bloc.add(ChangeConvertEvent(firstCurrency: 'UZS', secondCurrency: state.data![index].ccy!));
                            currency = state.data![index];
                            _showExchangeModalBottomSheet(context);
                          },
                          onDoubleTap: () {
                            widget.addedToFavorite();
                            bloc.add(AddCurrencyToFavoriteEvent(ccy: state.data![index].ccy!));
                          },
                        );
                      },
                    ),
                  );
                }
              }
            } else if (state.status == CurrencyPageStatus.fail) {
              Center(child: Text(state.errorMessage ?? 'Unknown Error'));
            }
            return Center();
          },
        ),
      ),
    );
  }

  Future<LanguageStatus?> _showModalBottomSheet(BuildContext context, LanguageStatus langStatus) async {
    return await showModalBottomSheet<LanguageStatus>(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context: context,
                title: 'Русский',
                isSelected: langStatus == LanguageStatus.rus,
                onTap: () => Navigator.pop(context, LanguageStatus.rus),
              ),
              _buildLanguageOption(
                context: context,
                title: 'Uzbek',
                isSelected: langStatus == LanguageStatus.uz,
                onTap: () => Navigator.pop(context, LanguageStatus.uz),
              ),
              _buildLanguageOption(
                context: context,
                title: 'Kirill',
                isSelected: langStatus == LanguageStatus.kiril,
                onTap: () => Navigator.pop(context, LanguageStatus.kiril),
              ),
              _buildLanguageOption(
                context: context,
                title: 'English',
                isSelected: langStatus == LanguageStatus.eng,
                onTap: () => Navigator.pop(context, LanguageStatus.eng),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({required BuildContext context, required String title, required bool isSelected, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? CupertinoColors.systemBlue : CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isSelected ? [BoxShadow(color: CupertinoColors.systemGrey.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 4))] : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: isSelected ? CupertinoColors.white : CupertinoColors.black, fontWeight: FontWeight.w600, fontSize: 17),
              ),
              if (isSelected) Icon(CupertinoIcons.check_mark, color: CupertinoColors.white, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showDatePicker(BuildContext context) async {
    DateTime date = DateTime.now();
    final Completer<String?> completer = Completer<String?>();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 350,
          padding: const EdgeInsets.only(top: 16.0),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: Offset(0, -2))],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text('Готово', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 16, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                          completer.complete(formattedDate);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: CupertinoColors.separator.resolveFrom(context)),
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: date,
                    maximumDate: date,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    showDayOfWeek: true,
                    onDateTimeChanged: (DateTime newDate) {
                      date = newDate;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return completer.future;
  }

  void _showExchangeModalBottomSheet(BuildContext context) {
    final bloc = BlocProvider.of<CurrencyPageBloc>(context);
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
                bloc.add(ChangeConvertEvent(firstCurrency: secondCurrency!, secondCurrency: firstCurrency));
                bloc.add(ConvertEvent(converted: 0.0));
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
                            BlocBuilder<CurrencyPageBloc, CurrencyPageState>(
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
                      BlocBuilder<CurrencyPageBloc, CurrencyPageState>(
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
                                bloc.add(ConvertEvent(converted: converted));
                              } else if (inputValue == null) {
                                bloc.add(ConvertEvent(converted: 0.0));
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
