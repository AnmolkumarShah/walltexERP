import 'package:intl/intl.dart';

String dateFormat(DateTime dt) {
  return  DateFormat.yMMMEd().format(dt);
}

String dateFormatFromDataBase(String value) {
  return dateFormat(DateTime.fromMillisecondsSinceEpoch(
      int.parse(value.toString().split('(')[1].toString().split('+')[0])));
}

DateTime onlyDateFromDataBase(String value) {
  return DateTime.fromMillisecondsSinceEpoch(
      int.parse(value.toString().split('(')[1].toString().split('+')[0]));
}

String onlyDate(DateTime dt) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(dt);
  return formatted;
}

String onlyDateFromValue(String value) {
  return onlyDate(onlyDateFromDataBase(value));
}

String onlyDateNow() {
  return onlyDate(DateTime.now());
}
