import 'dart:developer';

import 'package:flutter/services.dart';

class NativeService {
  static const platform = MethodChannel("callkit.flutter.dev");
  static Future<String> getMessage() async {
    try {
      final res = await platform.invokeMethod("getMessage");
      log(res.toString());
      return res.toString();
    } catch (e) {
      throw e;
    }
  }

  static Future<void> startCall() async {
    try {
      await platform.invokeMethod("startCall");
    } catch (e) {
      throw e;
    }
  }
}
