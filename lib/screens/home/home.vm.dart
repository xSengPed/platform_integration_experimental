import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  late BuildContext context;
  SuspeciousNumber? suspeciousNumber;
  String result = "";
  HomeViewModel() {}

  void init() async {
    // DatabaseService.createSampleData();
  }

  void findNumber(String number) async {
    suspeciousNumber = await DatabaseService.findByNumber(number);
    notifyListeners();
  }

  void updateResult(String result) {
    this.result = result;
    notifyListeners();
  }
}
