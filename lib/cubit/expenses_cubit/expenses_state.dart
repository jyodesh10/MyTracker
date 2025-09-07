part of 'expenses_cubit.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object> get props => [];
}

class ExpensesInitial extends ExpensesState {}

class ExpensesLoading extends ExpensesState {}

class ExpensesLoaded extends ExpensesState {
  final List<Expenses> expenses;
  final List category;
  const ExpensesLoaded({required this.expenses, required this.category});

  @override
  List<Object> get props => [expenses, category];
}
class ExpensesOneMonth extends ExpensesState {
  final List<Expenses> expenses;
  const ExpensesOneMonth({required this.expenses});

  @override
  List<Object> get props => [expenses];
}
class ExpensesSevenDays extends ExpensesState {
  final List<Expenses> expenses;
  const ExpensesSevenDays({required this.expenses});

  @override
  List<Object> get props => [expenses];
}

class ExpensesError extends ExpensesState {}
