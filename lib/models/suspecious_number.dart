import 'package:isar/isar.dart';
part 'suspecious_number.g.dart';

@collection
class SuspeciousNumber {
  Id id = Isar.autoIncrement;
  String title, number;
  SuspeciousNumber({required this.title, required this.number});
}
