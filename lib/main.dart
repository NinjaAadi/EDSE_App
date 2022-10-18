import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  // Initialize hive
  await Hive.initFlutter();

  // Open the peopleBox
  await Hive.openBox('loginObj');
  runApp(App());
}
