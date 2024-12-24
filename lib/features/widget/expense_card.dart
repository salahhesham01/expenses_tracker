import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/utils/app_colors.dart';
import '../data/expense_model.dart';
import '../expense_cubit/expense_cubit.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(
            context.read<ExpenseCubit>().getCategoryIcon(expense.category),
            color: AppColors.forestGreen,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            '${expense.category} - ${DateFormat('yyyy-MM-dd').format(DateTime.parse(expense.date))}'),
        trailing: Text(
          '\$${expense.amount.toStringAsFixed(2)}',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]),
        ),
      ),
    );
  }
}
