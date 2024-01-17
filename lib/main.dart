// import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:retro/pages/demo.dart';

// import 'package:get/get.dart';
// import 'package:retro/controller/tapcontroller.dart';
// import 'package:retro/pages/demo.dart';
// import 'package:retro/demo.dart';
// import 'package:retro/pages/dashboard.dart';
import 'package:retro/router/router.dart';
import 'package:retro/services/alarmmanager.dart';
// import 'package:retro/services/backgroundservoces.dart';

// import 'package:retro/services/workmanager.dart';
import 'package:retro/widget/localnotification.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:nes_ui/nes_ui.dart';

void main() async {
  int alarmId = 1;

  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService().initNotification();

  runApp(const MyApp());
  await AndroidAlarmManager.cancel(alarmId);
  await AndroidAlarmManager.initialize();
  AndroidAlarmManager.periodic(
      const Duration(seconds: 3), alarmId, backgroundHandler,
      allowWhileIdle: true, rescheduleOnReboot: true, exact: true);
}

final _appRouter = AppRouter();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: flutterNesTheme(),
    );
  }
}
