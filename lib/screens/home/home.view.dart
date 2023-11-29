import 'dart:developer';

import 'package:callkit_experimental/components/my_button.dart';
import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/screens/home/home.vm.dart';
import 'package:callkit_experimental/screens/home/number.view.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:callkit_experimental/services/native_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  SuspeciousNumber? incomingNumber;
  HomeViewModel vm = HomeViewModel();
  PhoneState phoneStatus = PhoneState.nothing();

  PhoneState status = PhoneState.nothing();
  bool granted = false;

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

  void setStream() {
    PhoneState.stream.listen((event) async {
      // ignore: unnecessary_null_comparison
      final number = event.number.toString();
      final result = await DatabaseService.findByNumber(number);
      setState(() {
        phoneStatus = event;
        incomingNumber = result;
      });
    });
  }

  @override
  void initState() {
    setStream();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.init();
      // DatabaseService.checkForUpdate();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => vm,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.green[700],
          title: Text("Whocalls Clone Experimental"),
        ),
        body: Consumer<HomeViewModel>(builder: (
          context,
          con,
          child,
        ) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Phone Status :${phoneStatus.status}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              "Result :",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Visibility(
                            visible: !(phoneStatus.status ==
                                    PhoneStateStatus.NOTHING ||
                                phoneStatus.status ==
                                    PhoneStateStatus.CALL_ENDED),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${incomingNumber?.number}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${incomingNumber?.title}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          )
                          // Row(
                          //   children: [
                          //     Expanded(
                          //         child: Text(
                          //       "${incomingNumber?.number} ${incomingNumber?.title}",
                          //       style: TextStyle(fontSize: 18),
                          //     )),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  )),
                  // Spacer(),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.green[700]),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NumberView(),
                                    ));
                              },
                              child: Text("Suspecious Numbers")),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
