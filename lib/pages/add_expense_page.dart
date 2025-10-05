import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/cubit/amount_cubit/amount_cubit.dart';
import 'package:my_tracker/db/expenses.dart';
import 'package:my_tracker/db_controller/db_controller.dart';
import 'package:my_tracker/themes.dart';
import 'package:my_tracker/utils/dateformatter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../cubit/currency_cubit/currency_cubit.dart';
import '../cubit/expenses_cubit/expenses_cubit.dart';
import '../utils/shared_pref.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key, required this.tab});
  final int tab;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final List<String> calInputs = [
    "1",
    "2",
    "3",
    "C",
    "4",
    "5",
    "6",
    "",
    "7",
    "8",
    "9",
    "",
    "",
    "0",
    ".",
    "✔️",
  ];

  List categorys = [
    "Grocery",
    "Insurace",
    "Rent",
    "Food and Drinks",
    "Miscelleanous",
    "Internet",
    "Shopping",
    "Transportation",
  ];

  String selectedCategory = "";

  TextEditingController descriptionCon = TextEditingController();

  DateTime selectedDate = DateTime.now();


  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1999), 
      lastDate: DateTime(2050),
      currentDate: DateTime.now(),
      initialDate: DateTime.now()
    );

    setState(() {
      if(pickedDate != null) {
        selectedDate = pickedDate;
      } else {
        selectedDate = DateTime.now();
      }
    });
  }

  @override
  void dispose () {
    super.dispose();
    descriptionCon.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense", style: titlestyle(context).copyWith(color: Colors.blueAccent)),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10.sp),
              BlocBuilder<AmountCubit, String>(
                builder: (context, state) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    // color: Colors.black,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${context.watch<CurrencyCubit>().state}  ",
                          style: lighttitlestyle(context).copyWith(fontSize: 20.sp),
                        ),
                        Flexible(
                          child: Text(
                            state.toString(),
                            style: titlestyle(context).copyWith(fontSize: 24.sp, overflow: TextOverflow.ellipsis,),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 10.sp),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text("Category", style: lighttitlestyle(context)),
                    subtitle: DropdownButtonFormField(
                      items: categorys
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.toString(),
                              child: Text(
                                e.toString(),
                                style: lighttitlestyle(context).copyWith(fontSize: 15.sp),
                              ),
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(
                        hintText: "select category",
                        hintStyle: lighttitlestyle(context).copyWith(fontSize: 15.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.sp)
                        )
                      ),
                      onChanged: (value) {
                        selectedCategory = value.toString();
                      },
                    )
                    // BlocBuilder<CategoryCubit, CategoryState>(
                    //   builder: (context, state) {
                    //     if(state is CategoryLoaded) {
                    //       return DropdownButtonFormField(
                    //         items: state.categories
                    //             .map(
                    //               (e) => DropdownMenuItem(
                    //                 value: e.name.toString(),
                    //                 child: Text(
                    //                   e.name.toString(),
                    //                   style: lighttitlestyle.copyWith(fontSize: 15.sp),
                    //                 ),
                    //               ),
                    //             )
                    //             .toList(),
                    //         decoration: InputDecoration(
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(15.sp)
                    //           )
                    //         ),
                    //         onChanged: (value) {
                    //           selectedCategory = value.toString();
                    //         },
                    //       );
                    //     } 
                    //     return SizedBox();
                    //   },
                    // ),
                  ),
                  ListTile(
                    title: Text("Description", style: lighttitlestyle(context)),
                    subtitle: TextField(
                      controller: descriptionCon,
                      maxLines: 2,
                      style: lighttitlestyle(context).copyWith(fontSize: 15.sp),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.sp)
                        )
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      pickDate();
                    }, 
                    child: Text("Choose Date: ${dateFormatter(selectedDate)}", style: lighttitlestyle(context),)
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height:  14.sp
          ),
          Expanded(
            flex: 15,
            child: GridView.builder(
              itemCount: calInputs.length,
              padding: EdgeInsets.all(10.sp),
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.sp,
                mainAxisSpacing: 10.sp,
              ),
              itemBuilder: (context, index) {
                return ClipRSuperellipse(
                  borderRadius: BorderRadius.circular(20.sp),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.sp),
                    onTap: () async {
                      final int? parsedVal = int.tryParse(
                        calInputs[index].toString(),
                      );
                      if (parsedVal != null) {
                        if (parsedVal < 10) {
                          context.read<AmountCubit>().setAmount(
                            calInputs[index].toString(),
                          );
                        }
                      } else if (calInputs[index] == ".") {
                        context.read<AmountCubit>().setAmount(
                          calInputs[index].toString(),
                        );
                      } else if (calInputs[index] == "C") {
                        context.read<AmountCubit>().clear();
                      // } else if (calInputs[index] == "") {
                      //   context.read<CategoryCubit>().addCategories();
                      } else if (calInputs[index] == "✔️") {
                        if(selectedCategory != "") {
                          String actualamt = "";
                          if(SharedPref.read("selectedCurrency")!=null) {
                            switch(SharedPref.read("selectedCurrency")) {
                              case "\$":
                              actualamt = (double.parse(context.read<AmountCubit>().userValue)/ SharedPref.read("USD")).toStringAsFixed(2);
                              break;
                              case "Rs.":
                              actualamt = (double.parse(context.read<AmountCubit>().userValue)/ (SharedPref.read("INR")*1.6)).toString();
                              break;
                              default:
                              actualamt = context.read<AmountCubit>().userValue;
                            }
                          } else {
                            actualamt = context.read<AmountCubit>().userValue;
                          }
                          final amt = Expenses()
                            ..amount = actualamt
                            ..category = selectedCategory
                            ..description = descriptionCon.text
                            ..date = selectedDate;
                          await DbController.isar.writeTxn(() async {
                            await DbController.isar.expenses.put(amt);
                          });
                          if (context.mounted) {
                            // fetchDb();
                            context.read<AmountCubit>().clear();
                            if (widget.tab == 0) {
                              context.read<ExpensesCubit>().fetchExpenses();
                            } else if (widget.tab == 1) {
                              context.read<ExpensesCubit>().fetchExpensesToday();
                            } else {
                              context.read<ExpensesCubit>().fetchExpensesThisMonth();
                            }
                            Navigator.pop(context);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red.shade400,
                              content: Text("Select a category!", style: lighttitlestyle(context).copyWith(fontSize: 15.sp, color: Colors.white),),
                            )
                          );
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withAlpha(40),
                      ),
                      child: Center(
                        child: Text(
                          calInputs[index].toString(),
                          style: titlestyle(context).copyWith(fontSize: 20.sp, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20.sp,
          )
        ],
      ),
    );
  }
}
