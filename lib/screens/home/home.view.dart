import 'package:callkit_experimental/components/my_button.dart';
import 'package:callkit_experimental/screens/home/home.vm.dart';
import 'package:callkit_experimental/screens/home/number.view.dart';
import 'package:callkit_experimental/services/native_service.dart';
import 'package:flutter/material.dart';
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
                  Row(
                    children: [
                      Expanded(
                        child: MyButton(
                          onPressed: () {},
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
                          onPressed: () {},
                          child: Text(
                            "Call Test (iOS)",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
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
