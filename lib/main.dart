import 'package:callkit_experimental/screens/home/home.view.dart';
import 'package:callkit_experimental/services/api_services.dart';
import 'package:callkit_experimental/services/callkit_service.dart';
import 'package:callkit_experimental/services/database_service.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiServices.init();
  CallKitService.init();

  DatabaseService.init();

  runApp(AppMain());
}

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}
