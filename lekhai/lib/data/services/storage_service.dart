import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import '../models/slip.dart';

class StorageService {
  Future<String> saveSlipImage(
    File sourceImage,
    String customerName,
    DateTime date,
  ) async {
    final dir = await getApplicationDocumentsDirectory();

    final customerFolder = Directory("${dir.path}/$customerName");
    if (!customerFolder.existsSync())
      customerFolder.createSync(recursive: true);

    final dateFolder = Directory(
      "${customerFolder.path}/${date.toString().substring(0, 10)}",
    );
    if (!dateFolder.existsSync()) dateFolder.createSync(recursive: true);

    final newPath =
        "${dateFolder.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
    return (await sourceImage.copy(newPath)).path;
  }

  Future<void> saveSlip(Slip slip) async {
    final box = await Hive.openBox<Slip>('slips');
    await box.add(slip);
  }

  Future<List<Slip>> getAllSlips() async {
    final box = await Hive.openBox<Slip>('slips');
    return box.values.toList();
  }
}
