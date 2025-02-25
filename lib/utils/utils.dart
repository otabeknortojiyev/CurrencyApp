import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(' ', '');
    if (newText.isEmpty) return newValue;
    final formattedText = NumberFormat("#,##0", "en_US").format(int.parse(newText)).replaceAll(',', ' ');
    return TextEditingValue(text: formattedText, selection: TextSelection.collapsed(offset: formattedText.length));
  }
}

String formatRate(String rate) {
  final parts = rate.split('.');
  final integerPart = parts[0];
  final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
  final numericString = integerPart.replaceAll(RegExp(r'[^0-9]'), '');
  final number = int.tryParse(numericString) ?? 0;
  final formatter = NumberFormat.decimalPattern('ru');
  final formattedIntegerPart = formatter.format(number);
  return '$formattedIntegerPart$decimalPart';
}

String formatNumber(String numberStr) {
  double? number = double.tryParse(numberStr.replaceAll(',', '.'));
  if (number == null) return numberStr;

  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else {
    return number.toStringAsFixed(1);
  }
}

String formatNumberDouble(double number) {
  if (number >= 1e9) {
    return '${(number / 1e9).toStringAsFixed(1)}B';
  } else if (number >= 1e6) {
    return '${(number / 1e6).toStringAsFixed(1)}M';
  } else if (number >= 1e3) {
    return '${(number / 1e3).toStringAsFixed(1)}K';
  } else {
    return number.toStringAsFixed(1);
  }
}

