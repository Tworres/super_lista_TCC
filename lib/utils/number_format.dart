import 'package:intl/intl.dart';

class NumberformatSl {

  static format(double number, {int decimalDigits =2}){
      final NumberFormat formatter = NumberFormat.decimalPatternDigits(
          locale: 'pt_br',
          decimalDigits: decimalDigits,
      );


      return formatter.format(number);
  }
}