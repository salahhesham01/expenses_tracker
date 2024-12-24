import 'package:go_router/go_router.dart';

import '../../features/splash/view/splash_view.dart';
import '../../features/view/add_page.dart';
import '../../features/view/expense_list_view.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(path: "/", builder: (context, state) => const SplashView()),
  GoRoute(
    path: "/expenseList",
    builder: (context, state) => const ExpenseListView(),
  ),
  GoRoute(
    path: "/add",
    builder: (context, state) => const AddExpensePage(),
  ),
]);
