import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/expense_dp_helper.dart';
import '../data/expense_model.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseDBHelper _dbHelper;
  int currentTabIndex = 0;

  ExpenseCubit(this._dbHelper) : super(ExpenseInitial()) {
    fetchExpenses();
  }

  void updateTabIndex(int index) {
    if (currentTabIndex == index) return; // Prevent redundant state changes
    currentTabIndex = index;
    emit(ExpenseTabChanged(index));
  }

  Future<void> fetchExpenses() async {
    try {
      emit(ExpenseLoading());
      final expenses = await _dbHelper.getExpenses();
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError('Failed to load expenses: ${e.toString()}'));
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      emit(ExpenseLoading());
      await _dbHelper.addExpense(expense);
      final expenses = await _dbHelper.getExpenses();
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      if (state is ExpenseLoaded) {
        final currentState = state as ExpenseLoaded;
        final updatedExpenses =
            currentState.expenses.where((expense) => expense.id != id).toList();
        emit(ExpenseLoaded(updatedExpenses));
      }
      await _dbHelper.deleteExpense(id);
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  final Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant,
    'Entertainment': Icons.movie,
    'Transport': Icons.directions_bus,
    'Shopping': Icons.shopping_bag,
    'Health': Icons.health_and_safety,
    'General': Icons.category,
  };

  IconData getCategoryIcon(String category) =>
      _categoryIcons[category] ?? Icons.help_outline;

  Future<void> loadMonthlyExpenses() async {
    try {
      final expenses = await _dbHelper.getExpenses();

      // Group by month and calculate totals
      final Map<String, double> monthlyData = {};
      for (var expense in expenses) {
        final month =
            expense.date.split('-').sublist(1, 2).join('-'); // e.g., "2023-12"
        monthlyData[month] = (monthlyData[month] ?? 0) + expense.amount;
      }

      emit(MonthlyExpenseLoaded(monthlyData));
    } catch (e) {
      emit(ExpenseError('Failed to load monthly data: ${e.toString()}'));
    }
  }
}
