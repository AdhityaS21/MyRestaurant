part of 'nightmode_bloc.dart';

class NightmodeState extends Equatable {
 final ThemeMode themeMode;

  NightmodeState(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}