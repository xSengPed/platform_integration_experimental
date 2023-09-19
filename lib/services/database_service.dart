// import 'dart:developer';

import 'dart:developer';
import 'dart:io';

import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/utils/utils.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

List<SuspeciousNumber> sampleDatas = [
  SuspeciousNumber(title: "ลุงโฟน", number: "0910533948"),
  SuspeciousNumber(title: "Phone 2", number: "0910533949"),
  SuspeciousNumber(title: "Phone 3", number: "0910533950"),
  SuspeciousNumber(title: "โรซี่ มิจฉาชีพ (หลอกผู้ชาย)", number: "0910533951"),
];

class DatabaseService {
  static String _serviceName = "Database";
  static late Isar _db;

  Future<void> setUp() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      _db =
          await Isar.open([SuspeciousNumberSchema], directory: directory.path);
      createSampleData();
    } catch (err) {
      log(err.toString());
      throw Exception("Exception : Failed to connect with service");
    }
  }

  DatabaseService.init() {
    serviceLog("$_serviceName", "Setting Up");
    setUp();
  }

  static Future<void> createSampleData() async {
    try {
      int itemCount = await _db.collection<SuspeciousNumber>().count();
      if (itemCount == 0) {
        serviceLog("$_serviceName", "Create Sample Datas");
        await _db.writeTxn(() async {
          for (SuspeciousNumber item in sampleDatas) {
            await _db.collection<SuspeciousNumber>().put(item);
          }
        });
      } else {
        return;
        // throw Exception("Exception : Failed to Create Sample Datas");
      }
    } catch (err) {
      rethrow;
    }
  }

  static Future<SuspeciousNumber?> findByNumber(String number) async {
    try {
      serviceLog("$_serviceName", "find by number $number");
      final SuspeciousNumber? result = await _db
          .collection<SuspeciousNumber>()
          .filter()
          .numberMatches(number)
          .findFirst();
      return result;
    } catch (err) {
      rethrow;
    }
  }
}
