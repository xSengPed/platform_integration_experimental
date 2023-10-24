import 'dart:developer';
import 'package:callkit_experimental/components/my_button.dart';
import 'package:callkit_experimental/screens/blocking_and_idf.view.dart';
import 'package:callkit_experimental/screens/calling_page_android.dart';

import 'package:callkit_experimental/screens/home/home.vm.dart';
import 'package:callkit_experimental/screens/home/number.view.dart';

import 'package:callkit_experimental/services/callkit_service.dart';
import 'package:callkit_experimental/services/native_service.dart';
import 'package:callkit_experimental/services/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel vm = HomeViewModel();

  @override
  void initState() {
    PermissionService.requestIncommingCallPerm();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.init();
      CallKitService.configure();
      // DatabaseService.checkForUpdate();
    });

    super.initState();
  }

  void onEvent(CallEvent event) {
    if (!mounted) return;

    print("${event.toString()}\n");
    setState(() {
      // textEvents += '${event.toString()}\n';
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> listenEvent(void Function(CallEvent) callback) async {
    try {
      FlutterCallkitIncoming.onEvent.listen((event) async {
        print(event.toString());
        // print(event.body.toString());
      });
    } catch (e) {
      log(e.toString());
    }
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
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CallingPageAndroid(),
                                ));
                          },
                          child: Text(
                            "Call (Android)",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: MyButton(
                          onPressed: () async {
                            // CallKitService.performIncomingCall("1111", "1112");
                            await CallKitService.triggerIncomingCall();
                          },
                          child: Text(
                            "Call Test (iOS)",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          onPressed: () async {},
                          child: Text(
                            "Open Setting",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BlockingAndIdentifyView(),
                                ));
                          },
                          child: Text(
                            "Go Blocking and Identify",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Native Method Channel",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MyButton(
                              child: Text(
                                "Get Network Status",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              onPressed: () async {
                                final result =
                                    await NativeService.getNetworkStatus();
                                con.updateResult(result);
                              })),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                            child: Text(
                              "Get Message From Native",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            onPressed: () async {
                              final result = await NativeService.getMessage();

                              con.updateResult(result);
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                            child: Text(
                              "Get Compute From Native",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            onPressed: () async {
                              final result =
                                  await NativeService.getCompute(10, 20, "*");
                              con.updateResult(result);
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
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
                              "Result :",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "${con.result}",
                                style: TextStyle(fontSize: 18),
                              )),
                            ],
                          )
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
