import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../expense_cubit/expense_cubit.dart';
import '../expense_cubit/expense_state.dart';
import 'expense_card.dart';

class ExpenseListContent extends StatelessWidget {
  const ExpenseListContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpenseLoaded) {
          final totalAmount =
              state.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
          final expenses = state.expenses;

          if (expenses.isEmpty) {
            return Center(
              child: Text(
                'No expenses added yet.',
                style: TextStyle(fontSize: mediaQuery.size.width * 0.05),
              ),
            );
          }

          return Column(
            children: [
              // Total Spend Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade200, Colors.green.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.attach_money,
                          color: Colors.white, size: 32),
                      Text(
                        'Total: \$${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Expense List
              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return Dismissible(
                      key: Key(
                          expense.id.toString()), // Unique key for each item
                      direction: DismissDirection.endToStart, // Swipe direction
                      onDismissed: (_) {
                        context.read<ExpenseCubit>().deleteExpense(expense.id!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${expense.title} deleted!"),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.delete, color: Colors.white),
                          ],
                        ),
                      ),
                      child: ExpenseCard(expense: expense),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ExpenseError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
