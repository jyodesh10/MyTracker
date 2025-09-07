import "package:intl/intl.dart";

dateFormatter(DateTime date) {
  // DateTime converted =  DateTime.parse(date);
  return DateFormat.MMMEd().format(date);
}