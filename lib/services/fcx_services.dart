import 'package:flutter_callkit_voximplant/flutter_callkit_voximplant.dart';

class FCXService {
  FCXPlugin _plugin = FCXPlugin();
  FCXProvider _provider = FCXProvider();
  FCXCallController _callController = FCXCallController();

  init() async {
    FCXProviderConfiguration cfg = FCXProviderConfiguration("",
        supportedHandleTypes: {FCXHandleType.PhoneNumber});
    await _callController.configure();
    await _provider.configure(cfg);
  }
}
