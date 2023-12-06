import 'dart:async';

import 'package:callkit_experimental/services/api_services.dart';
import 'package:callkit_experimental/services/background_task.dart';
import 'package:callkit_experimental/services/database_service.dart';

import 'package:callkit_experimental/services/system_alert.dart';
import 'package:flutter/material.dart';
import 'package:system_alert_window/system_alert_window.dart';

import 'screens/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseService.init();

  await SystemAlertWindow.registerOnClickListener(SystemAlert.callBackFunction);

  await initializeService();
  runApp(AppMain());
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
