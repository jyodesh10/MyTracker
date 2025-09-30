

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
    );
  }
  

  Future<List<Map<String, dynamic>>> exportUsersToJson() async {
    // Use .where().findAll() to select all objects, then call exportJson()
    final List<Map<String, dynamic>> expensesJsonList = 
        await isar.expenses.where().exportJson();
    
    return expensesJsonList;
  }

  // storeDb(Expenses e) async {
  //   await isar.writeTxn(() async {
  //     await isar.expenses.put(e);
  //   });
  // }

  // Future<List<Expenses>> readDb() async {
  //   final existingexpenses = await isar.expenses.where().findAll(); // get
  //   return existingexpenses;
  // }
}