import 'package:callkit_experimental/components/caller_ident.dart';
import 'package:callkit_experimental/components/my_button.dart';
import 'package:callkit_experimental/screens/home/view_model/home_viewmodel.dart';
import 'package:callkit_experimental/services/native_service.dart';
import 'package:callkit_experimental/services/system_alert.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel = HomeViewModel(context);

  @override
  void initState() {
    _viewModel.requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Exvention : Whocalls POC"),
              elevation: 0,
            ),
            backgroundColor: Colors.blue[900],
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Phone Status",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Text(
                                      "${vm.isPhonePermGranted.toString().toUpperCase()}"),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await NativeService.getMessage();
                                  },
                                  child: Text("test")),
                              ElevatedButton(
                                  onPressed: () async {
                                    await NativeService.startCall();
                                  },
                                  child: Text("test 2")),
                              Row(
                                children: [
                                  Text(
                                    "System Alert Status",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Text(
                                      "${vm.isSystemAlertGranted.toString().toUpperCase()}")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    child: vm.numbers.length == 0
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                  child: Text(
                                "No Numbers Data",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              itemCount: vm.numbers.length,
                              itemBuilder: (context, index) {
                                return CallerIndentityCard(
                                  caller: vm.numbers[index],
                                  onTapDelete: () =>
                                      vm.deleteNumber(vm.numbers[index].number),
                                );
                              },
                            ),
                          )),
                ElevatedButton(
                    onPressed: () {
                      SystemAlert.showIncomingCallerNotify();
                    },
                    child: Text("Show ALert")),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: Colors.white,
                  child: MyButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: vm.formKey,
                              child: Column(children: [
                                TextFormField(
                                  controller: vm.titleController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "required fied";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                TextFormField(
                                  controller: vm.numberController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "required fied";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyButton(
                                        onPressed: () {
                                          vm.submitNewNumber();
                                        },
                                        child: Text("Submit"),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Create New Number"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
