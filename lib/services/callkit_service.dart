import 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';
import 'package:uuid/uuid.dart';

class CallKitService {
  static late FCXProvider provider;
  static late FCXCallController controller;
  static late FCXPlugin plugin;
  CallKitService.init() {
    provider = FCXProvider();
    controller = FCXCallController();
    plugin = FCXPlugin();
  }

  static Future<void> triggerIncomingCall() async {
    FCXCallUpdate callUpdate = FCXCallUpdate(
      remoteHandle: FCXHandle(FCXHandleType.PhoneNumber, "0910533948"),
      supportsGrouping: false,
      supportsUngrouping: false,
      supportsHolding: true,
      supportsDTMF: true,
      hasVideo: false,
    );
    await provider.reportNewIncomingCall(Uuid().v4(), callUpdate);
  }

  static Future<void> addBlockedNumber(String number) async {
    int num = int.parse(number);
    await plugin.addBlockedPhoneNumbers([FCXCallDirectoryPhoneNumber(num)]);
  }

  static Future<List<String>> getBlockedNumbers() async {
    List<FCXCallDirectoryPhoneNumber> numbers =
        await plugin.getBlockedPhoneNumbers();
    return numbers.map((e) => e.number.toString()).toList();
  }

  static Future<void> addIdentifiedNumber(String number, String id) async {
    int num = int.parse(number);
    var phone = FCXIdentifiablePhoneNumber(num, label: id);
    await plugin.addIdentifiablePhoneNumbers([phone]);
  }

  static Future<List<FCXIdentifiablePhoneNumber>> getIdentifiedNumbers() async {
    return await plugin.getIdentifiablePhoneNumbers();
  }
}
