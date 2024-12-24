import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../expense_cubit/expense_cubit.dart';
import '../expense_cubit/expense_state.dart';

class MonthChartPage extends StatelessWidget {
  const MonthChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Expense Chart'),
      ),
      body: BlocBuilder<ExpenseCubit, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MonthlyExpenseLoaded) {
            final monthlyData = state.monthlyData;

            if (monthlyData.isEmpty) {
              return const Center(
                  child: Text(
                'No data available for the chart.',
                style: TextStyle(fontSize: 16),
              ));
            }

            // Determine the maximum value for amber highlighting
            final maxValue = monthlyData.values.isNotEmpty
                ? monthlyData.values.reduce((a, b) => a > b ? a : b)
                : 0;

            final pieChartSections = monthlyData.entries.map((entry) {
              return PieChartSectionData(
                value: entry.value,
                title: '\$${entry.value.toStringAsFixed(0)}',
                color: entry.value == maxValue
                    ? const Color(0xFFFFC107) // Amber color for max value
                    : Colors.primaries[
                        entry.key.hashCode % Colors.primaries.length],
                radius: 70, // Uniform size for all slices
                titleStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pie Chart
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: pieChartSections,
                        sectionsSpace: 4,
                        centerSpaceRadius: 50,
                        startDegreeOffset: -90,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),

                  // Legend
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: monthlyData.entries.length,
                      itemBuilder: (context, index) {
                        final entry = monthlyData.entries.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              // Category Color Indicator
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: entry.value == maxValue
                                      ? const Color(0xFFFFC107) // Amber color
                                      : Colors.primaries[entry.key.hashCode %
                                          Colors.primaries.length],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Category and Total
                              Expanded(
                                child: Text(
                                  '${entry.key}: \$${entry.value.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ExpenseError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
