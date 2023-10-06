import 'dart:developer';

import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:flutter/material.dart';

class NumberViewModel extends ChangeNotifier {
  BuildContext context;
  List<SuspeciousNumber> numbers = [];
  NumberViewModel(this.context);

  init() async {
    numbers = await DatabaseService.getAllNumber();

    log(numbers.toString());
    notifyListeners();
  }
}
