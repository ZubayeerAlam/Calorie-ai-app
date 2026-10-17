import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/local_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await LocalStorageService.init();
  runApp(CalAiApp(storage: storage));
}
