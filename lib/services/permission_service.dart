import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestIncommingCallPerm() async {
    PermissionStatus status = await Permission.phone.request();
    return switch (status) {
      PermissionStatus.denied ||
      PermissionStatus.restricted ||
      PermissionStatus.limited ||
      PermissionStatus.permanentlyDenied =>
        false,
      PermissionStatus.provisional || PermissionStatus.granted => true,
    };
  }
}
