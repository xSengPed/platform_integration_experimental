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
    const platform = MethodChannel("callkit.flutter.dev");
    try {
      final res = await platform.invokeMethod("getMessage");

      log(res.toString());
      return res.toString();
    } catch (e) {
      throw e;
    }
  }

  static Future<String> getCompute(double x, double y, String operand) async {
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
}
