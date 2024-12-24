import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/functions/themes.dart';
import 'core/routes/app_routes.dart';
import 'features/data/expense_dp_helper.dart';
import 'features/expense_cubit/expense_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseCubit(ExpenseDBHelper.instance),
      child: MaterialApp.router(
        theme: appTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
