import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/cubit/amount_cubit/amount_cubit.dart';
import 'package:my_tracker/cubit/expenses_cubit/expenses_cubit.dart';
import 'package:my_tracker/pages/add_expense_page.dart';
import 'package:my_tracker/pages/edit_expense_page.dart';
import 'package:my_tracker/utils/dateformatter.dart';
import 'package:my_tracker/widgets/indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;

  sumup(List<double> amt) {
    return amt.fold(0.0, (p, c) => p + c).toStringAsFixed(2);
  }

  Color interpolateColor(Color start, Color end, double t) {
    return Color.lerp(start, end, t)!;
  }

  final List<Color> harmoniousColors = [
    Colors.teal,
    Colors.deepPurple,
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    // context.read<CategoryCubit>().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // appBar: AppBar(),
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ExpensesCubit, ExpensesState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.4,
                            child: PieChart(
                              PieChartData(
                                centerSpaceRadius: 40.sp,
                                sectionsSpace: 5.sp,
                                sections: state is ExpensesLoaded 
                                  ? List.generate(state.category.length , (index) {
                                    return PieChartSectionData(
                                      value: double.parse(sumup(state.expenses.where((e) => e.category == state.category[index]).toList().map((e) => double.parse(e.amount.toString())).toList())),
                                      title: state.category[index],
                                      titleStyle: lighttitlestyle.copyWith(fontSize: 12.sp),
                                      color: harmoniousColors[index % harmoniousColors.length],
                                      radius: 22.sp,
                                      showTitle: false,
                                      titlePositionPercentageOffset: 2,
                                    );
                                  })
                                  : [
                                    PieChartSectionData(
                                      badgePositionPercentageOffset: 0.5,
                                    ),
                                    PieChartSectionData(
                                      badgePositionPercentageOffset: 0.5,
                                    ),
                                    PieChartSectionData(
                                      badgePositionPercentageOffset: 0.5,
                                    ),
                                  ],
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(seconds: 2),
                            curve: Curves.fastEaseInToSlowEaseOut,
                            child: Text(
                              state is ExpensesLoaded
                                ? "€ ${sumup(state.expenses.map((e) => double.parse(e.amount.toString())).toList())}"
                                : "€ 000",
                              style: titlestyle.copyWith(
                                color: Colors.blueAccent,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      state is ExpensesLoaded
                        ? GridView.count(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          childAspectRatio: 5,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(state.category.length, (index) {
                            return Indicator(
                              color: harmoniousColors[index % harmoniousColors.length],
                              text: state.category[index].toString(),
                              isSquare: true,
                            );
                          }),
                        )
                        : SizedBox()
                    ],
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(15.sp),
                child: TabBar(
                  // controller: TabController(length: 2, vsync: this.vsync),
                  indicatorColor: Colors.blueAccent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2.sp,
                  labelColor: Colors.blueAccent,
                  dividerHeight: 0,
                  labelStyle: lighttitlestyle.copyWith(fontSize: 14.sp),
                  onTap: (value) {
                    tab = value;
                    if (value == 0) {
                      context.read<ExpensesCubit>().fetchExpenses();
                    } else if(value == 1)  {
                      context.read<ExpensesCubit>().fetchExpensesToday();
                    } else {
                      context.read<ExpensesCubit>().fetchExpensesThisMonth();
                    }
                  },
                  tabs: [
                    Tab(text: "All"),
                    Tab(text: "Today"),
                    Tab(text: "This month"),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<ExpensesCubit, ExpensesState>(
                  builder: (context, state) {
                    if (state is ExpensesLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.expenses.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            contentPadding: EdgeInsets.only(left: 15.sp),
                            title: Text(
                              state.expenses[index].category.toString(),
                              style: lighttitlestyle,
                            ),
                            subtitle: Text(
                              state.expenses[index].description.toString(),
                              style: lighttitlestyle.copyWith(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                            trailing: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "- € ${state.expenses[index].amount.toString()}",
                                      style: lighttitlestyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      dateFormatter(state.expenses[index].date),
                                      style: lighttitlestyle.copyWith(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                  color: Colors.white.withAlpha(250),
                                  borderRadius: BorderRadius.circular(15.sp),
                                  shape: RoundedSuperellipseBorder(
                                    borderRadius: BorderRadius.circular(15.sp),
                                  ),
            
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        labelTextStyle:WidgetStateProperty.all(lighttitlestyle.copyWith(fontSize: 15.sp)),
                                        child: Text("Edit"),
                                        onTap: () {
                                          context.read<AmountCubit>().clear();
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => EditExpensePage(tab: tab, expenseData: state.expenses[index],),
                                          ));
                                        },
                                      ),
                                      PopupMenuItem(
                                        labelTextStyle:WidgetStateProperty.all(lighttitlestyle.copyWith(fontSize: 15.sp)),
                                        child: Text("Delete"),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Delete Expense", style: titlestyle.copyWith(fontSize: 16.sp),),
                                              content: Text("Are you sure you want to delete this expense?", style: lighttitlestyle.copyWith(fontSize: 15.sp)),
                                              shape: RoundedSuperellipseBorder(
                                                borderRadius: BorderRadius.circular(15.sp),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel", style: lighttitlestyle.copyWith(fontSize: 15.sp),),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    context.read<ExpensesCubit>().deleteItem(id: state.expenses[index].id, tab: tab);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Delete", style: lighttitlestyle.copyWith(fontSize: 15.sp, color: Colors.red),),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ];
                                  },
                                )
                                // IconButton(
                                //   onPressed: () {
                                //   },
                                //   icon: Icon(Icons.more_vert_rounded, color: Colors.blueAccent),
                                // ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent.shade200,
          onPressed: () {
            context.read<AmountCubit>().clear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpensePage(tab: tab,)),
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
