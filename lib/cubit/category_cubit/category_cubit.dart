import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:my_tracker/db/category.dart';
import 'package:my_tracker/db_controller/db_controller.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  List categorys = [
    "Grocery",
    "Insurace",
    "Rent",
    "Food and Drinks",
    "Miscelleanous",
    "Internet",
    "Shopping",
    "Transportation",
  ];

  addCategories() async {
    for (var e in categorys) {
      final cat = Category()..name = e;
      await DbController.isar.writeTxn(() async {
        await DbController.isar.categorys.put(cat);
      });
    }
  }

  fetchCategories() async {
    try {
      emit(CategoryLoading());
      var data = await DbController.isar.categorys.where().findAll();
      emit(CategoryLoaded(categories: data));
    } on Exception {
      emit(CategoryError());
    }
  }
  
}
