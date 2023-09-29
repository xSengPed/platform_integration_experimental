import 'package:callkit_experimental/screens/home/home.vm.dart';
import 'package:callkit_experimental/services/api_services.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel vm = HomeViewModel();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.init();
      DatabaseService.checkForUpdate();
    });
    super.initState();
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
                  // CallKitService.incommingTest("0910533948");

                  await ApiServices.getUpdate();
                },
                child: Text("Call")),
          ],
        ),
      ),
    );
  }
}
