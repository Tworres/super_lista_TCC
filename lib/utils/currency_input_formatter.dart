import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = double.tryParse(newValue.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0 / 100;

    String newText = _currencyFormat.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  static double? unformat(String value) {
    String cleanedValue = value.replaceAll('R\$', '').replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '.');

    return double.tryParse(cleanedValue);
  }

  static String format(double? value){
    if(value == null) return '';
    return _currencyFormat.format(value);
  }
}
