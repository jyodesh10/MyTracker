import 'package:isar/isar.dart';

part 'expenses.g.dart';

@collection
class Expenses {
  Id id = Isar.autoIncrement;
  String? amount;
  DateTime date = DateTime.now();
  String? description;
  String? category;
}
