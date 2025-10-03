

import 'dart:typed_data';

import 'package:isar/isar.dart';
import 'package:my_tracker/db/category.dart';
import 'package:my_tracker/db/expenses.dart';
import 'package:path_provider/path_provider.dart';

class DbController {
  static late final Isar isar;

  static Future<void> setup() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [ExpensesSchema, CategorySchema],
      directory: dir.path,
      inspector: true, 
    );
  }
  

  Future<List<Map<String, dynamic>>> exportExpenses() async {
    // Use .where().findAll() to select all objects, then call exportJson()
    final List<Map<String, dynamic>> expensesJsonList = 
        await isar.expenses.where().exportJson();
    
    return expensesJsonList;
  }


  static Future<void> importExpenses(Uint8List jsonBytes) async {
    await isar.writeTxn(() async {
      await isar.expenses.importJsonRaw(jsonBytes);
    });
  }

  static Future<void> deleteAllExpenses() async {
    await isar.writeTxn(() async {
      await isar.expenses.clear();
    });
  }
}