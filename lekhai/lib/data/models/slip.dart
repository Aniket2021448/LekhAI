import 'package:hive/hive.dart';

part 'slip.g.dart';

@HiveType(typeId: 0)
class Slip extends HiveObject {
  @HiveField(0)
  String customerName;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String imagePath;

  @HiveField(3)
  Map<String, dynamic> structuredData;

  Slip({
    required this.customerName,
    required this.date,
    required this.imagePath,
    required this.structuredData,
  });
}
