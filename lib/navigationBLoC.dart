import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigateEvent{toRestaurant, toFavorite, toMe, toSetting}
enum FavoriteEvent{toFavorite, toUnFavorite}

class NavigateBloc extends Bloc<NavigateEvent, int>{
  int? index;

  NavigateBloc(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(NavigateEvent event) async*{
    switch(event) {
      case NavigateEvent.toRestaurant:
        yield index = 0;
        break;
      case NavigateEvent.toFavorite:
        yield index = 1;
        break;
      case NavigateEvent.toMe:
        yield index = 2;
        break;
      case NavigateEvent.toSetting:
        yield index = 3;
        break;    
    }
  }
}

class FavoriteBloc extends Bloc<FavoriteEvent, Icon>{
  Icon? icon;

  FavoriteBloc(Icon initialState) : super(initialState);

  @override
  Stream<Icon> mapEventToState(FavoriteEvent event) async*{
    icon = (event == FavoriteEvent.toFavorite) ? Icon(Icons.favorite) : Icon(Icons.favorite_border, color: Colors.grey);
    yield icon!;
  }
  
}
