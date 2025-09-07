import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:my_tracker/db/expenses.dart';

import '../../db_controller/db_controller.dart';

part 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit() : super(ExpensesInitial());

  List category = [];
  fetchExpenses() async {
    try {
      emit(ExpensesLoading());
      var data = await DbController.isar.expenses.where().sortByDateDesc().findAll();
      category = data.map((e) => e.category).toSet().toList();
      emit(ExpensesLoaded(expenses: data, category: category));
    } on Exception {
      emit(ExpensesError());
    }
    
  }

  fetchExpensesThisMonth() async {
    try {
      emit(ExpensesLoading());
      var data = await DbController.isar.expenses.filter().dateBetween(DateTime.now().subtract(Duration(days: DateTime.now().day)), DateTime.now()).sortByDateDesc().findAll();
      category = data.map((e) => e.category).toSet().toList();
      emit(ExpensesLoaded(expenses: data, category: category));
    } on Exception {
      emit(ExpensesError());
    }
    
  }

  fetchExpensesToday() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      emit(ExpensesLoading());
      var data = await DbController.isar.expenses.filter().dateGreaterThan(startOfDay, include: true).dateLessThan(endOfDay).sortByDateDesc().findAll();
      category = data.map((e) => e.category).toSet().toList();
      emit(ExpensesLoaded(expenses: data, category: category));
    } on Exception {
      emit(ExpensesError());
    }
    
  }

  // fetchExpensesOneMonth() async {
  //   try {
  //     emit(ExpensesLoading());
  //     var data = await DbController.isar.expenses.filter().dateBetween(DateTime.now().subtract(Duration(days: 30)), DateTime.now()).sortByDateDesc().findAll();
  //     emit(ExpensesLoaded(expenses: data));
  //   } on Exception {
  //     emit(ExpensesError());
  //   }
    
  // }

  // fetchExpensesSevenDays() async {
  //   try {
  //     emit(ExpensesLoading());
  //     var data = await DbController.isar.expenses.filter().dateBetween(DateTime.now().subtract(Duration(days: 7)), DateTime.now()).sortByDateDesc().findAll();
  //     emit(ExpensesLoaded(expenses: data));
  //   } on Exception {
  //     emit(ExpensesError());
  //   }
    
  // }

  deleteItem({required int id,required int tab}) async {
    try {
      await DbController.isar.writeTxn(() async {
        await DbController.isar.expenses.delete(id);
      });
      if(tab == 0) {
        fetchExpenses();
      } else if(tab == 1) {
        fetchExpensesToday();
      } else {
        fetchExpensesThisMonth();
      }
    } on Exception {
      emit(ExpensesError());
    }
  }
}
