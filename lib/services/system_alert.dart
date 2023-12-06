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

  static SystemWindowHeader header = SystemWindowHeader(
      title: SystemWindowText(
          text: "Incoming Call", fontSize: 10, textColor: Colors.black45),
      padding: SystemWindowPadding.setSymmetricPadding(12, 12),
      subTitle: SystemWindowText(
          text: "9898989899",
          fontSize: 14,
          fontWeight: FontWeight.BOLD,
          textColor: Colors.black87),
      decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
      button: SystemWindowButton(
          text: SystemWindowText(
              text: "Close", fontSize: 10, textColor: Colors.black45),
          tag: "close_btn"),
      buttonPosition: ButtonPosition.TRAILING);

  static SystemWindowHeader getAlert(String telephoneNo, String title) {
    return SystemWindowHeader(
        title: SystemWindowText(
            text: "Incoming Call", fontSize: 10, textColor: Colors.black45),
        padding: SystemWindowPadding.setSymmetricPadding(12, 12),
        subTitle: SystemWindowText(
            text: "$telephoneNo\n$title",
            fontSize: 14,
            fontWeight: FontWeight.BOLD,
            textColor: Colors.black87),
        decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
        button: SystemWindowButton(
            text: SystemWindowText(
                text: "Close", fontSize: 10, textColor: Colors.black45),
            tag: "close_btn"),
        buttonPosition: ButtonPosition.TRAILING);
  }
}
