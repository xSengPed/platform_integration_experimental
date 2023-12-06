import 'dart:developer';

import 'package:permission_handler/permission_handler.dart';
import 'package:system_alert_window/system_alert_window.dart';

void serviceLog(String service, String? message) {
  log("[${service.toUpperCase()}] - ${message ?? ""}");
}

class Utils {
  static Future<bool> requestSyetemAlertWindowPermission() async {
    try {
      log("[Permission] - requestSyetemAlertWindowPermission");
      await SystemAlertWindow.requestPermissions(
          prefMode: SystemWindowPrefMode.DEFAULT);
      return true;
    } catch (err) {
      log(err.toString());
      return false;
    }
  }

  static Future<bool> requestPhomePermissionStatus() async {
    log("[Permission] - requestPhomePermissionStatus");
    try {
      var status = await Permission.phone.request();
      return switch (status) {
        PermissionStatus.denied ||
        PermissionStatus.restricted ||
        PermissionStatus.limited ||
        PermissionStatus.permanentlyDenied =>
          false,
        PermissionStatus.provisional || PermissionStatus.granted => true,
      };
    } catch (err) {
      log(err.toString());
      throw err;
    }
  }
}
