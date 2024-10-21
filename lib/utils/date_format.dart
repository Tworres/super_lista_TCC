import 'package:intl/intl.dart';

class DateFormatSl {
  late DateFormat _formatter;

  DateFormatSl(pattern) {
    _formatter = DateFormat(pattern, 'pt_br');
  }

  format(DateTime date) {
    var utcOffset = const Duration(hours: 3);

    date.subtract(utcOffset);

    return _formatter.format(date);
  }
}
