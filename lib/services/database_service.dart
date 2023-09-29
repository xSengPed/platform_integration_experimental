// import 'dart:developer';

import 'dart:developer';
import 'dart:io';
import 'package:callkit_experimental/models/caller_number.dart';
import 'package:callkit_experimental/models/suspecious_number.dart';
import 'package:callkit_experimental/services/api_services.dart';
import 'package:callkit_experimental/utils/utils.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

List<SuspeciousNumber> sampleDatas = [];

class DatabaseService {
  static String _serviceName = "Database";
  static late Isar _db;

  Future<void> setUp() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      _db =
          await Isar.open([SuspeciousNumberSchema], directory: directory.path);
      // createSampleData();
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

      if (result == null) {
        return SuspeciousNumber(title: number, number: number);
      }

      return result;
    } catch (err) {
      log("err");
      rethrow;
    }
  }

//   final existingPerson = await isar.writeTxn((isar) async {
//   // Check if a person with the same name exists
//   return isar.persons.where().nameEqualTo(person.name).findFirst();
// });

  static Future<bool> findExisting(String number, String title) async {
    final SuspeciousNumber? res = await _db.writeTxn(() async {
      return _db
          .collection<SuspeciousNumber>()
          .where()
          .filter()
          .numberEqualTo(number)
          .titleEqualTo(title)
          .findFirst();
    });
    if (res != null) {
      return true;
    } else {
      return false;
    }
  }

  static checkForUpdate() async {
    log('check for update');
    final bool canUpdate = await ApiServices.getVersion();
    if (true == canUpdate) {
      List<CallerNumber> response = await ApiServices.getUpdate();
      final List<SuspeciousNumber> store =
          await _db.collection<SuspeciousNumber>().where().findAll();

      if (true == store.isEmpty) {
        // Store is Empty
        // log("Start From Empty");
        for (CallerNumber caller in response) {
          await _db.writeTxn(() async {
            await _db.collection<SuspeciousNumber>().put(
                SuspeciousNumber(title: caller.title!, number: caller.number!));
          });
        }
      } else {
        // log("Start From Existing");
        for (CallerNumber callerNumber in response) {
          log(callerNumber.title.toString());
          if (callerNumber.number != null) {
            final bool isExist =
                await findExisting(callerNumber.number!, callerNumber.title!);
            if (!isExist) {
              await _db.writeTxn(() async {
                await _db.collection<SuspeciousNumber>().put(SuspeciousNumber(
                    title: callerNumber.title!, number: callerNumber.number!));
              });
            }
          } else {
            throw Exception("Error!");
          }
        }
      }
    } else {
      return;
    }
  }
}
