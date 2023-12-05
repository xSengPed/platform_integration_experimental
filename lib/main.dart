import 'dart:async';
import 'dart:developer';

import 'package:callkit_experimental/services/api_services.dart';
import 'package:callkit_experimental/services/background_task.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:callkit_experimental/services/system_alert.dart';
import 'package:flutter/material.dart';
import 'package:system_alert_window/system_alert_window.dart';

import 'screens/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ApiServices.init();
  DatabaseService.init();
  // SystemAlert.initConfig();
  await initializeService();
  SystemAlertWindow.registerOnClickListener(callBackFunction);
  runApp(AppMain());
}

@pragma('vm:entry-point')
void callBackFunction(String tag) {
  switch (tag) {
    case "simple_button":
      print("Simple button has been clicked");
      break;
    case "focus_button":
      print("Focus button has been clicked");
      break;
    case "close_btn":
      print("close_btn button has been clicked");
      SystemAlertWindow.closeSystemWindow();
      break;
    default:
      print("OnClick event of $tag");
  }
}

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  reqPerm() async {
    await SystemAlertWindow.requestPermissions;
  }

  @override
  void initState() {
    reqPerm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}
