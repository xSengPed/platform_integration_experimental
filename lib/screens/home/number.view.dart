import 'package:callkit_experimental/screens/home/number.vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NumberView extends StatefulWidget {
  const NumberView({super.key});

  @override
  State<NumberView> createState() => _NumberViewState();
}

class _NumberViewState extends State<NumberView> {
  late NumberViewModel vm;

  TextEditingController titleController = TextEditingController();
  TextEditingController telController = TextEditingController();

  @override
  void initState() {
    vm = NumberViewModel(context);
    vm.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          elevation: 0,
          title: Text("Suspecious Numbers"),
        ),
        body: Consumer<NumberViewModel>(
          builder: (context, con, child) {
            return Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: con.numbers.length,
                    itemBuilder: (context, index) => Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(con.numbers[index].title),
                            SizedBox(
                              height: 8,
                            ),
                            Text(con.numbers[index].number),
                            Row(
                              children: [
                                Spacer(),
                                ElevatedButton(
                                    onPressed: () {
                                      vm.delete(con.numbers[index].number);
                                    },
                                    child: Text("Delete"))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        child: Text(
                          "Add Number",
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: titleController,
                                      ),
                                      TextField(
                                        maxLength: 10,
                                        keyboardType: TextInputType.number,
                                        controller: telController,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            vm.add(telController.text,
                                                titleController.text);

                                            telController.clear();
                                            titleController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Text("Confirm"))
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ))
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
