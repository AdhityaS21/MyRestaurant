part of 'nightmode_bloc.dart';

abstract class NightmodeEvent extends Equatable {
  const NightmodeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends NightmodeEvent{
  final bool value;

  ThemeChanged(this.value);

  @override
  List<Object> get props => [value];
}

class ThemeLoadStart extends NightmodeEvent{}