import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/cubit/category_cubit/category_cubit.dart';
import 'package:my_tracker/cubit/currency_cubit/currency_cubit.dart';
import 'package:my_tracker/cubit/expenses_cubit/expenses_cubit.dart';
import 'package:my_tracker/cubit/selected_expense_cubit/selected_expense_cubit.dart';
import 'package:my_tracker/cubit/theme_cubit/theme_cubit.dart';
import 'package:my_tracker/db_controller/db_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'cubit/amount_cubit/amount_cubit.dart';
import 'pages/splash_page.dart';
import 'utils/shared_pref.dart';

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
);

void main() async {
  await _setup();
  await SharedPref.init();
  runApp(BlocProvider(create: (context) => ThemeCubit()..checkTheme(), child: MyApp()));
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbController.setup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return ResponsiveSizer(
          builder: (p0, p1, p2) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AmountCubit()),
              BlocProvider(
                create: (context) {
                  if(SharedPref.read("tab")!=null) {
                    switch (SharedPref.read("tab")) {
                      case 0:
                        return ExpensesCubit()..fetchExpenses();
                      case 1:
                        return ExpensesCubit()..fetchExpensesToday();
                      case 2:
                        return ExpensesCubit()..fetchExpensesThisMonth();
                      default:
                        return ExpensesCubit()..fetchExpenses();
                    }
                  } else {
                    return ExpensesCubit()..fetchExpenses();
                  }
                }
              ),
              BlocProvider(
                create: (context) => CategoryCubit()..fetchCategories(),
              ),
              BlocProvider(
                create: (context) => CategoryCubit()..addCategories(),
              ),
              BlocProvider(
                create: (context) => CurrencyCubit()..checkcurrency(),
              ),
              BlocProvider(
                create: (context) => SelectedExpenseCubit(),
              ),
            ],
            child: MaterialApp(
              title: 'My Tracker',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state ?  ThemeMode.dark : ThemeMode.light,
              home: SplashPage(),
            ),
          ),
        );
      },
    );
  }
}
