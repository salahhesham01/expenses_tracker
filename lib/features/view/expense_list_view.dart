import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_colors.dart';
import '../expense_cubit/expense_cubit.dart';
import '../expense_cubit/expense_state.dart';
import '../widget/expense_list_content.dart';
import 'add_page.dart';
import 'monthly_chart_page.dart';

class ExpenseListView extends StatelessWidget {
  const ExpenseListView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ExpenseListContent(),
      AddExpensePage(),
      const MonthChartPage()
    ];

    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        final currentTab = context.read<ExpenseCubit>().currentTabIndex;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Expenses Tracker'),
            centerTitle: true,
          ),
          body: IndexedStack(
            index: currentTab,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentTab,
            onTap: (index) {
              context.read<ExpenseCubit>().updateTabIndex(index);

              if (index == 0) {
                context.read<ExpenseCubit>().fetchExpenses();
              } else if (index == 2) {
                context.read<ExpenseCubit>().loadMonthlyExpenses();
              }
            },
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.forestGreen,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: 'Expenses'),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart), label: 'Summary'),
            ],
          ),
        );
      },
    );
  }
}
