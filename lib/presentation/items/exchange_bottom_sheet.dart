import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../data/source/remote/response/currency_response.dart';
import '../../utils/utils.dart';
import '../main_screen/currency_page/bloc.dart';
import '../main_screen/currency_page/event.dart';
import '../main_screen/currency_page/state.dart';

void showExchangeModalBottomSheet(BuildContext context, CurrencyResponse currency) {
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
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
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
