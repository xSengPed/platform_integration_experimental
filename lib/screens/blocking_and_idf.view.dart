import 'package:callkit_experimental/components/my_button.dart';
import 'package:callkit_experimental/services/call_service.dart';
import 'package:callkit_experimental/services/callkit_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BlockingAndIdentifyView extends StatefulWidget {
  const BlockingAndIdentifyView({super.key});

  @override
  State<BlockingAndIdentifyView> createState() =>
      _BlockingAndIdentifyViewState();
}

class _BlockingAndIdentifyViewState extends State<BlockingAndIdentifyView> {
  TextEditingController textEditingController = TextEditingController();
  String result = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blocking and Identify View"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: textEditingController,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: MyButton(
                        child: Text("Add to Identify"),
                        onPressed: () async {
                          if (textEditingController.text.length < 10) {
                            return;
                          }
                          await CallKitService.addIdentifiedNumber(
                              textEditingController.text, Uuid().v4());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Identify Add : ${textEditingController.text}')));
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
                        child: Text("Add to Blocking"),
                        onPressed: () async {
                          if (textEditingController.text.length < 10) {
                            return;
                          }
                          await CallKitService.addBlockedNumber(
                              textEditingController.text);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Blocking Add : ${textEditingController.text}')));
                        })),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: MyButton(
                        color: Colors.red[700],
                        child: Text("Show Blocking"),
                        onPressed: () async {
                          final res = await CallKitService.getBlockedNumbers();
                          setState(() {
                            result = res.toString();
                          });
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
                        color: Colors.blue[800],
                        child: Text("Show Identifies"),
                        onPressed: () async {
                          final res =
                              await CallKitService.getIdentifiedNumbers();

                          final data =
                              res.map((e) => "\n[${e.label}]\n${e.number}");
                          setState(() {
                            result = data.toString();
                          });
                        })),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Flexible(
                child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24)),
              child: Column(children: [
                Row(
                  children: [Expanded(child: Text("Result : $result"))],
                )
              ]),
            ))
          ],
        ),
      ),
    );
  }
}
