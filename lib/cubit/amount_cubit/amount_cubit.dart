import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'amount_state.dart';

class AmountCubit extends Cubit<String> {
  AmountCubit() : super("");

  String userValue = "";
  
  setAmount(String amount) {
    userValue += amount.toString();
    log(userValue);
    emit(userValue);
  }

  clear() {
    userValue = "";
    emit(userValue);
  }
}
