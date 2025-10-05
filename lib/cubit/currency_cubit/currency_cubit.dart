import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/utils/shared_pref.dart';

import '../../data/api.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<String> {
  CurrencyCubit() : super("€");


  fetchCurrency() async {
    var data = await Api.getCurrency();
    var res = jsonDecode(data);
    SharedPref.write("EUR", res["data"]["EUR"]);
    SharedPref.write("INR", res["data"]["INR"]);
    SharedPref.write("USD", res["data"]["USD"]);
  }

  checkcurrency() {
    if(SharedPref.read("selectedCurrency")!=null) {
      emit(SharedPref.read("selectedCurrency"));
    } else {
      emit("€");
    }
  }

  selectedCurrency(String currency) {
    fetchCurrency();
    SharedPref.write("selectedCurrency", currency);
    emit(currency);
  }
}
