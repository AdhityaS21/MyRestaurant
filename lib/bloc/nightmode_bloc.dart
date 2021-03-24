import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:myrestaurant/sharedPreferences.dart';
part 'nightmode_event.dart';
part 'nightmode_state.dart';

class NightmodeBloc extends Bloc<NightmodeEvent, NightmodeState> {
  NightmodeBloc() : super(NightmodeState(ThemeMode.light));

  @override
  Stream<NightmodeState> mapEventToState(
    NightmodeEvent event,
  ) async* {
    if(event is ThemeLoadStart){
      yield* _mapThemeLoadStartedToState();
    }else if(event is ThemeChanged){
      yield* _mapThemeChangedToState(event.value);
    }
  }

  Stream<NightmodeState> _mapThemeLoadStartedToState() async*{
    final sharedPrefService = await SharedPreferencesService.instance;
    final isDarkModeEnabled = sharedPrefService!.isDarkModeEnabled;

    if(isDarkModeEnabled == null){
      sharedPrefService.setDarkModeInfo(false);
      yield NightmodeState(ThemeMode.light);
    }else{
      ThemeMode themeMode = isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light;
      yield NightmodeState(themeMode);
    }
  }

  Stream<NightmodeState> _mapThemeChangedToState(bool value) async* {
    final sharedPrefService =  await SharedPreferencesService.instance;
    final isDarkModeEnabled = sharedPrefService!.isDarkModeEnabled;

    if(value && !isDarkModeEnabled!){
      await sharedPrefService.setDarkModeInfo(true);
      yield NightmodeState(ThemeMode.dark);
    }else if(!value && isDarkModeEnabled!){
      await sharedPrefService.setDarkModeInfo(false);
      yield NightmodeState(ThemeMode.light);
    }
  }
}
