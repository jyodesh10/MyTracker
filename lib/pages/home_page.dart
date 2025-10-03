import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/cubit/amount_cubit/amount_cubit.dart';
import 'package:my_tracker/cubit/expenses_cubit/expenses_cubit.dart';
import 'package:my_tracker/pages/add_expense_page.dart';
import 'package:my_tracker/pages/edit_expense_page.dart';
import 'package:my_tracker/pages/settings_page.dart';
import 'package:my_tracker/utils/dateformatter.dart';
import 'package:my_tracker/utils/shared_pref.dart';
import 'package:my_tracker/widgets/indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../themes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int tab = 0;

  sumup(List<double> amt) {
    return amt.fold(0.0, (p, c) => p + c).toStringAsFixed(2);
  }

  Color interpolateColor(Color start, Color end, double t) {
    return Color.lerp(start, end, t)!;
  }

  final List<Color> harmoniousColors = [
    Colors.purple,
    Colors.teal,
    Colors.deepPurple,
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.green,
    Colors.indigo,
  ];

  late TabController tabController;
  List<Map> cat = [];
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: SharedPref.read("tab") ?? 0, length: 4, vsync: this, animationDuration: Duration(milliseconds: 100))..addListener(() {
      handleTabChange(tabController.index);
    },);
  }

  void handleTabChange(int value) async {
    if (tab == value) return; // Do nothing if tab hasn't changed
    tab = value;
    SharedPref.write("tab", value);
    if (value == 0) {
      context.read<ExpensesCubit>().fetchExpenses();
    } else if (value == 1) {
      context.read<ExpensesCubit>().fetchExpensesToday();
    } else if (value == 2) {
      context.read<ExpensesCubit>().fetchExpensesThisMonth();
    } else {
      DateTimeRange<DateTime>? dateRange = await showDateRangePicker(
        context: context, 
        barrierColor: Colors.white,
        firstDate: DateTime(2001), 
        lastDate: DateTime(2050),
        // builder: (context, child) => Theme(
        //   data: ThemeD, 
        //   child: child!
        // ),

      );
      if(dateRange !=null) {
        if(mounted) {
          context.read<ExpensesCubit>().fetchExpensesCustom(dateRange: dateRange);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: BlocBuilder<ExpensesCubit, ExpensesState>(
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
                                      cat = state.category.map((e) => {
                                        "name": e,
                                        "color": harmoniousColors[index % harmoniousColors.length],
                                      }).toList();
                                      return PieChartSectionData(
                                        value: double.parse(sumup(state.expenses.where((e) => e.category == state.category[index]).toList().map((e) => double.parse(e.amount.toString())).toList())),
                                        title: state.category[index],
                                        titleStyle: lighttitlestyle(context).copyWith(fontSize: 12.sp),
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
                                style: titlestyle(context).copyWith(
                                  color: Colors.blueAccent,
                                  fontSize: 22.sp,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10.sp,
                              right: 15.sp,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                                }, 
                                icon: Icon(Icons.settings)
                              ))
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
              ),
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Colors.white,
                pinned: true,
                elevation: 0,
                titleSpacing: 0,
                bottom: PreferredSize(
                  preferredSize: Size(100.w, 18.sp), 
                  child: Padding(
                    padding: EdgeInsets.all(15.sp),
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: Colors.blueAccent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 2.sp,
                      labelColor: Colors.blueAccent,
                      dividerHeight: 0,
                      labelStyle: lighttitlestyle(context).copyWith(fontSize: 14.sp),
                      onTap: (value) {
                        handleTabChange(value);
                      },
                      tabs: [
                        Tab(text: "All"),
                        Tab(text: "Today"),
                        Tab(text: "This month"),
                        Tab(text: "Custom"),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: BlocBuilder<ExpensesCubit, ExpensesState>(
            builder: (context, state) {
              if (state is ExpensesLoaded) {
                return TabBarView(
                  controller: tabController,
                  children: [
                    _buildExpensesListView(state),
                    _buildExpensesListView(state),
                    _buildExpensesListView(state),
                    _buildExpensesListView(state),
                  ],
                );
                
              } else if (state is ExpensesLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
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
    );
  }

  
  _buildExpensesListView(ExpensesLoaded state) {
    return ListView.builder(
      itemCount: state.expenses.length,
      padding: EdgeInsets.only(bottom: 30.sp),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.only(left: 15.sp),
          leading: CircleAvatar(
            backgroundColor: harmoniousColors[cat.indexWhere((e) => e["name"] == state.expenses[index].category) % harmoniousColors.length], 
            radius: 15.sp,
            child: Text(state.expenses[index].category.toString()[0], 
              style: titlestyle(context).copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ), 
            ),
          ),
          title: Text(
            state.expenses[index].category.toString(),
            style: lighttitlestyle(context),
          ),
          subtitle: Text(
            state.expenses[index].description.toString(),
            style: lighttitlestyle(context).copyWith(
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
                    style: lighttitlestyle(context).copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    dateFormatter(state.expenses[index].date),
                    style: lighttitlestyle(context).copyWith(
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
                      labelTextStyle:WidgetStateProperty.all(lighttitlestyle(context).copyWith(fontSize: 15.sp)),
                      child: Text("Edit"),
                      onTap: () {
                        context.read<AmountCubit>().clear();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => EditExpensePage(tab: tab, expenseData: state.expenses[index],),
                        ));
                      },
                    ),
                    PopupMenuItem(
                      labelTextStyle:WidgetStateProperty.all(lighttitlestyle(context).copyWith(fontSize: 15.sp)),
                      child: Text("Delete"),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Expense", style: titlestyle(context).copyWith(fontSize: 16.sp),),
                            content: Text("Are you sure you want to delete this expense?", style: lighttitlestyle(context).copyWith(fontSize: 15.sp)),
                            backgroundColor: Colors.white,
                            shape: RoundedSuperellipseBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel", style: lighttitlestyle(context).copyWith(fontSize: 15.sp),),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<ExpensesCubit>().deleteItem(id: state.expenses[index].id, tab: tab);
                                  Navigator.pop(context);
                                },
                                child: Text("Delete", style: lighttitlestyle(context).copyWith(fontSize: 15.sp, color: Colors.red),),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ];
                },
              )
            ],
          ),
        );
      },
    );
  }
}
