// Add Expense Page
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_colors.dart';
import '../data/expense_model.dart';
import '../expense_cubit/expense_cubit.dart';
import '../widget/custom_text_form_field.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'General';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'General',
    'Food',
    'Transport',
    'Entertainment',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.03),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Field (Custom Text Form Field)
              CustomTextFormField(
                controller: _titleController,
                label: 'Title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),

              // Amount Field (Custom Text Form Field)
              CustomTextFormField(
                controller: _amountController,
                label: 'Amount',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.tryParse(value)! <= 0) {
                    return 'Amount must be greater than zero';
                  }
                  return null;
                },
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),

              // Category Dropdown
              DropdownButtonFormField<String>(
                style: TextStyle(color: AppColors.forestGreen),
                value: _selectedCategory,
                items: _categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? 'General';
                  });
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: AppColors.forestGreen),
                  labelText: 'Category',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.forestGreen),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.forestGreen),
                  ),
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.01),

              // Date Picker
              Row(
                children: [
                  Chip(
                    label: Text(
                      'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.forestGreen,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text(
                      'Select Date',
                      style: TextStyle(color: Colors.green[800]),
                    ),
                  ),
                ],
              ),

              SizedBox(height: mediaQuery.size.height * 0.03),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newExpense = Expense(
                      title: _titleController.text.trim(),
                      amount: double.parse(_amountController.text),
                      category: _selectedCategory,
                      date: _selectedDate.toIso8601String(),
                    );

                    context.read<ExpenseCubit>().addExpense(newExpense);
                    _titleController.clear();
                    _amountController.clear();
                    _selectedCategory = 'General';
                    _selectedDate = DateTime.now();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Expense added successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Add Expense',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
