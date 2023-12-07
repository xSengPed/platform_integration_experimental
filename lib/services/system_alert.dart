import 'package:flutter/material.dart';
import 'package:system_alert_window/system_alert_window.dart';

class SystemAlert {
  SystemAlert.initializeSetting() {}

  @pragma('vm:entry-point')
  static void callBackFunction(String tag) {
    switch (tag) {
      case "simple_button":
        print("Simple button has been clicked");
        break;
      case "focus_button":
        print("Focus button has been clicked");
        break;
      case "close_btn":
        print("close_btn button has been clicked");
        SystemAlertWindow.closeSystemWindow();
        break;
      default:
        print("OnClick event of $tag");
    }
  }

  static showIncomingCallerNotify(
      {String number = "Number", String callerId = "CallerId"}) {
    SystemAlertWindow.showSystemWindow(
      // margin: SystemWindowMargin(left: 50),
      prefMode: SystemWindowPrefMode.DEFAULT,
      gravity: SystemWindowGravity.CENTER,
      height: 200,
      width: 300,
      header: SystemWindowHeader(
          title: SystemWindowText(
        text: "Incoming Call",
        fontSize: 16,
        fontWeight: FontWeight.BOLD,
        textColor: Colors.grey[900],
        padding: SystemWindowPadding(top: 24, right: 24, left: 24, bottom: 24),
      )),
      body: SystemWindowBody(
          padding: SystemWindowPadding(top: 0, right: 24, left: 24, bottom: 24),
          rows: [
            EachRow(columns: [
              EachColumn(
                text: SystemWindowText(text: "$number"),
              )
            ]),
            EachRow(columns: [
              EachColumn(
                text: SystemWindowText(text: "$callerId"),
              )
            ]),
          ]),
      footer: SystemWindowFooter(
          text: SystemWindowText(text: ""),
          buttonsPosition: ButtonPosition.TRAILING,
          padding: SystemWindowPadding(top: 0, right: 24, left: 0, bottom: 0),
          buttons: [
            SystemWindowButton(
              width: 30,
              decoration: SystemWindowDecoration(
                  startColor: Colors.blue,
                  borderRadius: 20,
                  endColor: Colors.amber),
              text: SystemWindowText(text: "Close", textColor: Colors.white),
              tag: "close_btn",
            )
          ]),
    );
  }
}
