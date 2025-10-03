import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_tracker/utils/shared_pref.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);

  void checkTheme() {
    if(SharedPref.read("isDarkTheme")!=null) {
      emit(SharedPref.read("isDarkTheme"));
    } else {
      emit(state);
    }
  }

  void toggleTheme() {
    SharedPref.write("isDarkTheme", !state);
    emit(!state);
  }
}
