import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/utils/shared_pref.dart';

import '../../data/api.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<String> {
  CurrencyCubit() : super("€");


  fetchCurrencyOnceAWeek() async {
    if(SharedPref.read("lastcalled")!=null) {
      final DateTime lastCalledTime = DateTime.fromMillisecondsSinceEpoch(SharedPref.read("lastcalled"));
      final DateTime currentTime = DateTime.now();
      if(currentTime.difference(lastCalledTime) > Duration(days: 7)) {
        fetchCurrency();
      }
    } else {
        fetchCurrency();
    }
  }

  fetchCurrency() async {
    var data = await Api.getCurrency();
    var res = jsonDecode(data);
    SharedPref.write("EUR", res["data"]["EUR"]);
    SharedPref.write("INR", res["data"]["INR"]);
    SharedPref.write("USD", res["data"]["USD"]);
    SharedPref.write("lastcalled", DateTime.now().millisecondsSinceEpoch);
  }

  checkcurrency() {
    if(SharedPref.read("selectedCurrency")!=null) {
      emit(SharedPref.read("selectedCurrency"));
    } else {
      emit("€");
    }
  }

  selectedCurrency(String currency) {
    fetchCurrencyOnceAWeek();
    SharedPref.write("selectedCurrency", currency);
    emit(currency);
  }
}
