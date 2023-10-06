import 'dart:developer';

import 'package:flutter/services.dart';

class NativeService {
  static Future<String> getNetworkStatus() async {
    const platform = MethodChannel("callkit.flutter.dev/network");
    try {
      final res = await platform.invokeMethod("getNetworkStatus");
      log(res.toString());
      return res.toString();
    } catch (e) {
      throw e;
    }
  }

  static Future<String> getMessage() async {
    const platform = MethodChannel("callkit.flutter.dev/message");
    try {
      final res = await platform.invokeMethod("getMessage");

      log(res.toString());
      return res.toString();
    } catch (e) {
      throw e;
    }
  }

  static Future<String> getCompute(int x, int y, String operand) async {
    const platform = MethodChannel("callkit.flutter.dev/compute");

    try {
      final res = await platform.invokeMethod("getCompute", {
        "x": x,
        "y": y,
        "operand": operand,
      });
      log(res.toString());
      return res.toString();
    } catch (e) {
      throw e;
    }
  }
  // static Future<void> getBatteryLevel() async {
  //   try {
  //     final res = await platform.invokeMethod('getNetworkStatus');
  //     print('OK + $res');
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // static Future<void> getMul() async {
  //   try {
  //     final res =
  //         await platform.invokeMethod('getMultiplyFromSwift', {"a": 4, "b": 5});
  //     print('OK + $res');
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }
}
