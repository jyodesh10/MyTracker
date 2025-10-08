import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'selected_expense_state.dart';

class SelectedExpenseCubit extends Cubit<List<int>> {
  SelectedExpenseCubit() : super([]);


  selectExpense({required int expense}){
    state.add(expense);
    debugPrint(state.toSet().toList().toString());
    emit(state.toSet().toList());
  }

  unselectExpense({required int expense}){
    state.remove(expense);
    debugPrint(state.toSet().toList().toString());
    emit(state.toSet().toList());
  }

  clearExpenses(){
    emit([]);
  }
}
