import 'package:currency_app/presentation/items/currency_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../data/source/remote/response/currency_response.dart';
import '../../items/date_picker.dart';
import '../../items/exchange_bottom_sheet.dart';
import '../../items/language_bottom_sheet.dart';
import '../../items/show_case_template.dart';
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
  final GlobalKey currencyItem = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ShowCaseWidget.of(context).startShowCase([currencyItem]);
  //   });
  // }

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
          if (state.showCaseView != null && state.showCaseView == false) {
            ShowCaseWidget.of(context).startShowCase([currencyItem]);
            context.read<CurrencyPageBloc>().add(DoNotShowCaseViewEvent());
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
                final selectedDate = await showMyDatePicker(context);
                if (selectedDate != null) {
                  bloc.add(GetCurrencyByDateEvent(date: selectedDate));
                }
              },
              child: SvgPicture.asset('assets/calendar_choose.svg', width: 24, height: 24),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () async {
                var status = await showLanguageModalBottomSheet(context, langStatus);
                if (status != null) {
                  bloc.add(ChangeLanguageEvent(status: status));
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
                        return index == 0
                            ? ShowCaseTemplate(
                              total: 1,
                              isFinished: true,
                              globalKey: currencyItem,
                              height: 100,
                              width: MediaQuery.of(context).size.width * 0.5,
                              shape: RoundedRectangleBorder(),
                              isTitleRequired: false,
                              description: "If you double tap on a currency, it will be added to your favorites.",
                              currentShowCase: "1",
                              child: CurrencyItem(
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
                                  showExchangeModalBottomSheet(context, currency);
                                },
                                onDoubleTap: () {
                                  widget.addedToFavorite();
                                  bloc.add(AddCurrencyToFavoriteEvent(ccy: state.data![index].ccy!));
                                },
                              ),
                            )
                            : CurrencyItem(
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
                                showExchangeModalBottomSheet(context, currency);
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
}
