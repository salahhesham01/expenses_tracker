import '../data/expense_model.dart';

class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  ExpenseLoaded(this.expenses);
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}

class ExpenseTabChanged extends ExpenseState {
  final int tabIndex;

  ExpenseTabChanged(this.tabIndex);
}

class ExpenseDeleting extends ExpenseState {
  final int expenseId;

  ExpenseDeleting(this.expenseId);
}

class MonthlyExpenseLoaded extends ExpenseState {
  final Map<String, double> monthlyData;

  MonthlyExpenseLoaded(this.monthlyData);
}
