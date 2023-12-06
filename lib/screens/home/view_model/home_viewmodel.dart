import 'dart:developer';

import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:callkit_experimental/utils/utils.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  BuildContext context;
  HomeViewModel(this.context) {
    loadNumbers();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  bool isPhonePermGranted = false;
  bool isSystemAlertGranted = false;

  List<SuspeciousNumber> numbers = [];

  Future<void> requestPermission() async {
    try {
      isPhonePermGranted = await Utils.requestPhomePermissionStatus();
      isSystemAlertGranted = await Utils.requestSyetemAlertWindowPermission();
      notifyListeners();
    } catch (err) {
      log(err.toString());
    }
  }

  Future<void> loadNumbers() async {
    numbers = await DatabaseService.getAllNumber();
    notifyListeners();
    log(numbers.length.toString());
  }

  Future<void> submitNewNumber() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        await DatabaseService.createNew(
            numberController.text, titleController.text);
        await loadNumbers();
        titleController.clear();
        numberController.clear();
        Navigator.pop(context);
      } catch (err) {
        log(err.toString());
      }
    }
  }

  Future<void> deleteNumber(String number) async {
    try {
      await DatabaseService.deleteByNumber(number);
      loadNumbers();
    } catch (err) {
      log(err.toString());
    }
  }
}
