import 'package:flutter/material.dart';
import 'package:system_alert_window/system_alert_window.dart';

class SystemAlert {
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

  SystemWindowHeader getAlert(String telephoneNo, String title) {
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
