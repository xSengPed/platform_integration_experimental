import 'dart:developer';

import 'package:flutter/services.dart';

class NativeService {
  static const platform = MethodChannel("callkit.flutter.dev/message");
  static Future<void> getBatteryLevel() async {
    try {
      final res = await platform.invokeMethod('getMessageFromSwift');
      print('OK + $res');
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<void> getMul() async {
    try {
      final res =
          await platform.invokeMethod('getMultiplyFromSwift', {"a": 4, "b": 5});
      print('OK + $res');
    } catch (e) {
      log(e.toString());
    }
  }
}
