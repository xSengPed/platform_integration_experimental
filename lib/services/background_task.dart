import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/services/database_service.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:phone_state/phone_state.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await DatabaseService().setUp();
  await service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  log("[BACKGROUND] - ON START");
  await DatabaseService().setUp();
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

  PhoneState.stream.listen((event) async {
    final SuspeciousNumber? result =
        await DatabaseService.findByNumber(event.number ?? "");
    log(result?.title ?? "-");
    log(result?.number ?? "-");

    // SystemAlertWindow.showSystemWindow(
    //     gravity: SystemWindowGravity.CENTER,
    //     margin: SystemWindowMargin(top: 100),
    //     prefMode: SystemWindowPrefMode.OVERLAY,
    //     header:
    //         SystemAlert.getAlert(result?.number ?? "", result?.title ?? ""));
  });
}
