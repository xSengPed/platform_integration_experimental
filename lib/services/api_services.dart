import 'dart:developer';
import 'dart:io';

import 'package:callkit_experimental/models/caller_number.dart';
import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class ApiServices {
  static late Dio dioClient;

  ApiServices.init() {
    final BaseOptions options = BaseOptions(
      baseUrl: "http://localhost:3000/api",
      connectTimeout: Duration(seconds: 15),
    );
    dioClient = Dio(options);
  }

  static Future<bool> getVersion() async {
    final sevicesRes = await dioClient.get("/getVersion");

    if (sevicesRes.statusCode == 200) {
      return sevicesRes.data["status"];
    } else {
      return false;
    }
  }

  static Future<List<CallerNumber>> getUpdate() async {
    final serviceRes = await dioClient.get("/getUpdate");

    if (serviceRes.statusCode == 200) {
      return List.generate(serviceRes.data.length,
          (index) => CallerNumber.fromJson(serviceRes.data[index]));
    } else {
      return [];
    }
  }
}
