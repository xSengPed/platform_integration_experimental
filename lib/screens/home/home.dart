import 'dart:developer';
import 'dart:isolate';

import 'package:callkit_experimental/services/system_alert.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:system_alert_window/system_alert_window.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<bool> requestPermission() async {
    var status = await Permission.phone.request();
    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }

  // void setStream() {
  //   PhoneState.stream.listen((event) {
  //     log(event.status.name);
  //   });
  // }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(
        prefMode: SystemWindowPrefMode.DEFAULT);
  }

  @override
  void initState() {
    // setStream();

    super.initState();
    requestPermission();
    _requestPermissions();
  }

  @pragma('vm:entry-point')
  void callBackFunction(String tag) {
    WidgetsFlutterBinding.ensureInitialized();
    switch (tag) {
      case "simple_button":
        print("Simple button has been clicked");
        break;
      case "focus_button":
        print("Focus button has been clicked");
        break;
      case "personal_btn":
        print("Personal button has been clicked");
        SystemAlertWindow.closeSystemWindow();
        break;
      default:
        print("OnClick event of $tag");
    }
  }

  void show() {
    SystemAlertWindow.showSystemWindow(
      header: SystemAlert.header,
      // body: SystemAlert.body,
      // footer: SystemAlert.footer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await SystemAlertWindow.requestPermissions(
                      prefMode: SystemWindowPrefMode.OVERLAY);
                  // SystemAlertWindow.showSystemWindow(header: header);

                  SystemAlertWindow.showSystemWindow(
                      height: 100,
                      width: (MediaQuery.of(context).size.width * 0.9).toInt(),
                      header: SystemAlert.header,
                      // body: SystemAlert.body,
                      // footer: SystemAlert.footer,
                      margin: SystemWindowMargin(
                          left: 8, right: 8, top: 100, bottom: 0),
                      gravity: SystemWindowGravity.TOP,
                      // notificationTitle: "Incoming Call",
                      // notificationBody: "+1 646 980 4741",
                      prefMode: SystemWindowPrefMode.DEFAULT);
                },
                child: Text("Show")),
            ElevatedButton(
                onPressed: () async {
                  SystemAlertWindow.closeSystemWindow();
                },
                child: Text("test")),
          ],
        ),
      ),
    );
  }
}
