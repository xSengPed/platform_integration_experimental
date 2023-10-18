import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';

class CallingPageAndroid extends StatefulWidget {
  const CallingPageAndroid({super.key});

  @override
  State<CallingPageAndroid> createState() => _CallingPageAndroidState();
}

class _CallingPageAndroidState extends State<CallingPageAndroid> {
  SuspeciousNumber? incommingCall;
  PhoneState phoneState = PhoneState.nothing();

  @override
  void initState() {
    super.initState();
    _initIncomingCallListener();
  }

  void _initIncomingCallListener() {
    PhoneState.stream.listen((PhoneState event) async {
      if (event.status == PhoneStateStatus.CALL_INCOMING) {
        final SuspeciousNumber? response =
            await DatabaseService.findByNumber(event.number ?? "");
        if (response != null) {
          setState(() {
            incommingCall = response;
          });
        }
      }
      setState(() {
        phoneState = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Phone State : ${phoneState.status}"),
            Text("Phone Number : ${phoneState.number}"),
            Row(
              children: [
                Expanded(
                  child: Divider(),
                )
              ],
            ),
            Text("Result"),
            Text("${incommingCall?.title ?? ""}"),
            Text("${incommingCall?.number ?? ""}"),
          ],
        ),
      ),
    );
  }
}
