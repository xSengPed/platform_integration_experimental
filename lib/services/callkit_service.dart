import 'dart:developer';

import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/services/database_service.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';
import 'package:uuid/uuid.dart';

class CallKitService {
  static FCXProvider provider = FCXProvider();

  static Future<void> performIncomingCall(String contact, String uuid) async {
    FCXCallUpdate callUpdate = FCXCallUpdate(localizedCallerName: contact);
    await provider.reportNewIncomingCall(uuid, callUpdate);
  }

  static incommingTest(String number) async {
    log("call");
    String currentUuid;
    currentUuid = Uuid().v4();

    SuspeciousNumber? suspeciousNumber =
        await DatabaseService.findByNumber(number);

    if (suspeciousNumber != null) {
      CallKitParams callKitParams = CallKitParams(
        id: currentUuid,
        nameCaller: suspeciousNumber.title,
        appName: 'Callkit',
        avatar: 'https://i.pravatar.cc/100',
        handle: suspeciousNumber.number,
        type: 0,
        textAccept: 'Accept',
        textDecline: 'Decline',
        missedCallNotification: NotificationParams(
          showNotification: true,
          isShowCallback: true,
          subtitle: 'Missed call',
          callbackText: 'Call back',
        ),
        duration: 30000,
        extra: <String, dynamic>{'userId': '1a2b3c4d'},
        headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
        android: const AndroidParams(
            isCustomNotification: true,
            isShowLogo: false,
            ringtonePath: 'system_ringtone_default',
            backgroundColor: '#0955fa',
            backgroundUrl: 'https://i.pravatar.cc/500',
            actionColor: '#4CAF50',
            incomingCallNotificationChannelName: "Incoming Call",
            missedCallNotificationChannelName: "Missed Call"),
        ios: IOSParams(
          iconName: 'CallKitLogo',
          handleType: 'generic',
          supportsVideo: true,
          maximumCallGroups: 2,
          maximumCallsPerCallGroup: 1,
          audioSessionMode: 'default',
          audioSessionActive: true,
          audioSessionPreferredSampleRate: 44100.0,
          audioSessionPreferredIOBufferDuration: 0.005,
          supportsDTMF: true,
          supportsHolding: true,
          supportsGrouping: false,
          supportsUngrouping: false,
          ringtonePath: 'system_ringtone_default',
        ),
      );
      await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
    } else {
      return;
    }
  }
}
