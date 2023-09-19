import 'dart:developer';

void serviceLog(String service, String? message) {
  log("[${service.toUpperCase()}] - ${message ?? ""}");
}

class Utils {}
