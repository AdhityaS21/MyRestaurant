import 'package:flutter/widgets.dart';

class SearchProvider with ChangeNotifier{
  int? _searchQuery;

  get searchQuery => _searchQuery;

  set searchQuery(svalue){
    _searchQuery = svalue;
    notifyListeners();
  }
}