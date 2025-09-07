import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/cubit/category_cubit/category_cubit.dart';
import 'package:my_tracker/cubit/expenses_cubit/expenses_cubit.dart';
import 'package:my_tracker/db_controller/db_controller.dart';
import 'package:my_tracker/pages/home_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'cubit/amount_cubit/amount_cubit.dart';

void main() async {
  await _setup();
  runApp(const MyApp());
  
}

Future<void> _setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DbController.setup();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) =>
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AmountCubit()),
            BlocProvider(create: (context) => ExpensesCubit()..fetchExpenses()),
            BlocProvider(create: (context) => CategoryCubit()..fetchCategories()),
            BlocProvider(create: (context) => CategoryCubit()..addCategories()),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: HomePage()
          ),
        )
    );
  }
}
