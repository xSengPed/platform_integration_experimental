///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

///  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.

import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class Call {
  final String uuid;
  final bool outgoing;
  final String callerName;
  bool muted = false;
  bool onHold = false;

  Call(this.outgoing, this.callerName) : uuid = _uuid.v4();
}

typedef CallChanged(Call? call);

class CallService {
  factory CallService() {
    return _cache ?? CallService._internal();
  }

  static CallService? _cache;

  CallService._internal()
      : _provider = FCXProvider(),
        _callController = FCXCallController(),
        _plugin = FCXPlugin() {
    _cache = this;
    _configure();
  }

  final FCXPlugin _plugin;
  final FCXProvider _provider;
  final FCXCallController _callController;
  Call? _managedCall;
  CallChanged? callChangedEvent;
  bool _configured = false;

  String? get callerName => _managedCall?.callerName;

  Future<void> emulateIncomingCall(String contactName) async {
    await _configure();

    Call managedCall = Call(false, contactName);
    _managedCall = managedCall;

    FCXCallUpdate callUpdate = FCXCallUpdate(
      remoteHandle: FCXHandle(FCXHandleType.PhoneNumber, contactName),
      supportsGrouping: false,
      supportsUngrouping: false,
      supportsHolding: true,
      supportsDTMF: true,
      hasVideo: false,
    );

    await _provider.reportNewIncomingCall(managedCall.uuid, callUpdate);
  }

  Future<void> emulateOutgoingCall(String contactName) async {
    await _configure();

    Call managedCall = Call(true, contactName);
    _managedCall = managedCall;

    FCXHandle handle = FCXHandle(FCXHandleType.PhoneNumber, contactName);

    FCXStartCallAction action = FCXStartCallAction(managedCall.uuid, handle);
    action.video = false;

    await _callController.requestTransactionWithAction(action);
  }

  Future<void> _configure() async {
    if (_configured) {
      return;
    }

    await _callController.configure();

    FCXProviderConfiguration configuration = FCXProviderConfiguration(
      'FlutterCallKit',
      iconTemplateImageName: 'CallKitLogo',
      includesCallsInRecents: true,
      supportsVideo: false,
      maximumCallsPerCallGroup: 1,
      supportedHandleTypes: {FCXHandleType.PhoneNumber, FCXHandleType.Generic},
    );

    await _provider.configure(configuration);

    _provider.performStartCallAction = (startCallAction) async {
      Call? call = _managedCall;
      if (call != null) {
        await _provider.reportOutgoingCall(call.uuid, null);
        await _provider.reportOutgoingCallConnected(call.uuid, null);
        await startCallAction.fulfill();
      }
    };

    _provider.performEndCallAction = (endCallAction) async {
      _managedCall = null;
      await endCallAction.fulfill();
      callChangedEvent?.call(_managedCall);
    };

    _provider.performAnswerCallAction = (answerCallAction) async {
      await answerCallAction.fulfill();
    };

    _provider.performPlayDTMFCallAction = (playDTMFCallAction) async {
      await playDTMFCallAction.fulfill();
    };

    _provider.performSetGroupCallAction = (setGroupCallAction) async {
      await setGroupCallAction.fulfill();
    };

    _provider.performSetHeldCallAction = (setHeldCallAction) async {
      _managedCall?.onHold = setHeldCallAction.onHold;
      await setHeldCallAction.fulfill();
      callChangedEvent?.call(_managedCall);
    };

    _provider.performSetMutedCallAction = (setMutedCallAction) async {
      _managedCall?.muted = setMutedCallAction.muted;
      await setMutedCallAction.fulfill();
      callChangedEvent?.call(_managedCall);
    };

    _callController.callObserver.callChanged = (call) async {};

    _configured = true;
  }

  Future<void> mute() async {
    Call? managedCall = _managedCall;
    if (managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXSetMutedCallAction action =
        FCXSetMutedCallAction(managedCall.uuid, !managedCall.muted);
    await _callController.requestTransactionWithAction(action);
  }

  Future<void> hold() async {
    Call? managedCall = _managedCall;
    if (managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXSetHeldCallAction action =
        FCXSetHeldCallAction(managedCall.uuid, !managedCall.onHold);
    await _callController.requestTransactionWithAction(action);
  }

  Future<void> sendDTMF(String digits) async {
    Call? managedCall = _managedCall;
    if (managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXPlayDTMFCallAction action = FCXPlayDTMFCallAction(
        managedCall.uuid, digits, FCXPlayDTMFCallActionType.singleTone);
    await _callController.requestTransactionWithAction(action);
  }

  Future<void> hangup() async {
    Call? managedCall = _managedCall;
    if (managedCall == null) {
      throw Exception('Managed call is missing');
    }
    FCXEndCallAction action = FCXEndCallAction(managedCall.uuid);
    await _callController.requestTransactionWithAction(action);
  }

  final String _extensionID =
      'com.voximplant.flutterCallkit.example.CallDirectoryExtension';

  Future<List<String>> getBlockedNumbers() async {
    var numbers = await _plugin.getBlockedPhoneNumbers();
    return numbers.map((e) => e.number.toString()).toList();
  }

  Future<void> addBlockedNumber(String number) async {
    int num = int.parse(number);
    await _plugin.addBlockedPhoneNumbers(
      [FCXCallDirectoryPhoneNumber(num)],
    );
  }

  Future<void> removeBlockedNumber(String number) async {
    int num = int.parse(number);
    await _plugin.removeBlockedPhoneNumbers(
      [FCXCallDirectoryPhoneNumber(num)],
    );
  }

  Future<List<FCXIdentifiablePhoneNumber>> getIdentifiedNumbers() async {
    return await _plugin.getIdentifiablePhoneNumbers();
  }

  Future<void> addIdentifiedNumber(String number, String id) async {
    int num = int.parse(number);
    var phone = FCXIdentifiablePhoneNumber(num, label: id);
    await _plugin.addIdentifiablePhoneNumbers([phone]);
  }

  Future<void> removeIdentifiedNumber(int number) async {
    await _plugin.removeIdentifiablePhoneNumbers(
      [FCXCallDirectoryPhoneNumber(number)],
    );
  }

  Future<void> openSettings() async {
    await FCXCallDirectoryManager.openSettings();
  }

  Future<void> reloadExtension() async {
    await FCXCallDirectoryManager.reloadExtension(_extensionID);
  }

  Future<String> getExtensionStatus() async {
    var status = await FCXCallDirectoryManager.getEnabledStatus(_extensionID);
    switch (status) {
      case FCXCallDirectoryManagerEnabledStatus.disabled:
        return 'Disabled';
      case FCXCallDirectoryManagerEnabledStatus.enabled:
        return 'Enabled';
      case FCXCallDirectoryManagerEnabledStatus.unknown:
      default:
        return 'Unknown';
    }
  }
}
