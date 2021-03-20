import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeEvent{toNightMode, toLightMode}

class ThemeBloc extends Bloc<ThemeEvent, Color>{
  Color? theme;
  ThemeBloc(Color initialState) : super(initialState);

  @override
  Stream<Color> mapEventToState(ThemeEvent event) async*{
    theme = (event == ThemeEvent.toNightMode) ? Colors.black : Colors.white;
    yield theme!;
  }
}