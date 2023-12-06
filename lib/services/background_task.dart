import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:callkit_experimental/services/system_alert.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:phone_state/phone_state.dart';
import 'package:system_alert_window/system_alert_window.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma("vm:enttry-point")
void onStart(ServiceInstance service) {
  DartPluginRegistrant.ensureInitialized();

  service.on("setAsForeground").listen((event) {
    log("setAsForeground" + event.toString());
  });

  service.on("setAsBackground").listen((event) {
    log("setAsBackground" + event.toString());
  });

  service.on("stopServices").listen((event) {
    log("setAsBackground" + event.toString());
    service.stopSelf();
  });

  PhoneState.stream.listen((event) {
    log(event.toString());
    SystemAlertWindow.showSystemWindow(
        gravity: SystemWindowGravity.CENTER,
        margin: SystemWindowMargin(top: 100),
        prefMode: SystemWindowPrefMode.OVERLAY,
        header: SystemAlert.getAlert(event.number.toString(), "TEST CALL"));
  });
}
