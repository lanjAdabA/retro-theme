import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:retro/constant/constant.dart';
import 'package:retro/model/soilmodel.dart';
import 'package:retro/services/alarmmanager.dart';
import 'package:retro/widget/localnotification.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GetxTapController extends GetxController {
  //setter
  Getallsoildetails? latestdata;
  Getallsoildetails? alldata;
  List _allsoildatamap = [];
  List _allsoildatamaplast10 = [];
  final List _allfeed = [];
  Feed? _latestfeeddata;
  // 5 minutes in seconds
  Timer? _timer;
  int pumptimer = 0;
  int _min = 0;
  int _sec = 0;

  bool _ismanualwaterconfirm = false;
  var isDataLoading = false.obs;
  bool _pumpStatusmanually = false;
  bool _isserverok = true;
  bool _pumpStatus = false;
  String _soiltitle = '';
  Timer? _scheduletimer;
  final List<DateTime> _alldatetime = [];
  List<DateTime> _alldatetimelast10 = [];
  late ZoomPanBehavior zoomPanBehavior;

  //getter
  bool get isserverok => _isserverok;
  List get allsoildatamap => _allsoildatamap;
  List get allsoildatamaplast10 => _allsoildatamaplast10;
  Timer get scheduletimer => _scheduletimer!;
  bool get iswatermanualconfirm => _ismanualwaterconfirm;
  List get allfeed => _allfeed;
  Feed? get latestfeeddata => _latestfeeddata;
  bool get pumpStatusmanually => _pumpStatusmanually;
  bool get pumpStatus => _pumpStatus;
  int get min => _min;
  int get sec => _sec;
  String get soiltitle => _soiltitle;
  List<DateTime> get alldatetime => _alldatetime;
  List<DateTime> get alldatetimelast10 => _alldatetimelast10;
  var data = <Feed>[].obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    if (_isserverok) {
      _startTimer();
      getlatestfeeddata();
      getalldata();
      getzoompan();
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  @override
  void onClose() {}

  Rx<VisualType?> selectedVisualType = Rx<VisualType?>(null);

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _scheduletimer!.cancel();
    super.dispose();
  }

  void getzoompan() {
    zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableSelectionZooming: true,
    );
  }

  void _startTimer() {
    // Create a periodic timer that executes the function every 5 seconds
    _scheduletimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      getlatestfeeddata();
      getalldata();

      log('Executing your function periodically...');
    });
  }

  void getsoildetailaccordingtoindex({required int index}) {
    switch (index) {
      case 0:
        _soiltitle = 'Soil Humidity';
        update();
        break;
      case 1:
        _soiltitle = 'Soil Temperature';
        update();
        break;
      case 2:
        _soiltitle = 'Soil PH Level';
        update();
        break;
      default:
    }
  }

  void setradiobuttoncancellationhandle() {
    selectedVisualType.value = null;
  }

  void updateSelectedVisualType(
      {required VisualType value, required int timerforpump}) {
    selectedVisualType.value = value;
    pumptimer = timerforpump * 60;
    update();
  }

  void setpumpmanually({
    required bool pumpstatus,
  }) {
    _pumpStatusmanually = pumpstatus;
    selectedVisualType.value = null;
    if (_timer != null) {
      _timer!.cancel();
      _ismanualwaterconfirm = false;
      _pumpStatus = false;
      _min = 0;
      _sec = 0;
      update();
    }
    update();
  }

  void setpump({required bool pumpstatus}) {
    _pumpStatus = pumpstatus;
    setwaterpump(isActive: true);
    if (_ismanualwaterconfirm == false) {
      NotificationService().showNotification(
          title: 'Water Pump Activated 🚰',
          body: 'Your water pump 💦 has been switched on successfully');
    }
    if (pumpStatus == false) {
      if (_ismanualwaterconfirm) {
        if (_timer != null) {
          setwaterpump(isActive: false);
          _timer!.cancel();
          _ismanualwaterconfirm = false;
          _pumpStatus = false;
          _min = 0;
          _sec = 0;
          selectedVisualType.value = null;
          update();
        }
      } else {
        setwaterpump(isActive: false);
        NotificationService().showNotification(
            title: 'Water Pump Deactivated 🚰',
            body: 'Your water pump 💦 has been switched off successfully');
      }
    }
    update();
  }

  Future getlatestfeeddata() async {
    if (latestdata == null) {
      isDataLoading(true);
    }
    try {
      final queryParameters = {
        "api_key": "330F3444455D4923",
      };
      final response = await http.get(
        Uri.http('10.10.1.139:88', '/api/channel-data/698633/latest-feeds',
            queryParameters),
      );
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        var users = getallsoildetailsFromJson(response.body);

        if (latestdata == null) {
          latestdata = users;
          _latestfeeddata = latestdata!.feeds.last;

          update();
        } else {
          if (users == latestdata) {
            log('Data Already same');
          } else {
            isDataLoading(true);
            latestdata = users;
            _latestfeeddata = latestdata!.feeds.last;

            update();
          }
        }

        print('Successfully get Data');
      } else {
        print('Failedrerer to Getdata.');
        _isserverok = false;
        update();
      }
      return null;
    } catch (e) {
      _isserverok = false;
      update();
      print(e.toString());
    } finally {
      isDataLoading(false);
    }
  }

  Future getalldata() async {
    try {
      final queryParameters = {
        "api_key": "330F3444455D4923",
        "interval": "60",
      };
      final response = await http.get(
        Uri.http('10.10.1.139:88', '/api/channel-data/698633/feeds',
            queryParameters),
      );
      // var soildata = jsonEncode(response.body);
      Map<String, dynamic> dec = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var users = getallsoildetailsFromJson(response.body);
        alldata = users;
        _allsoildatamap = dec['feeds'];
        var last10 = _allsoildatamap.sublist(_allsoildatamap.length - 10);

        _allsoildatamaplast10 = last10.reversed.toList();
        update();
        log('Last 10 :$_allsoildatamaplast10');

        for (var element in alldata!.feeds) {
          if (_alldatetime.contains(element.created)) {
            log('Already Exist');
          } else {
            _alldatetime.add(element.created);
          }
        }
        var last10datetime = _alldatetime.sublist(_alldatetime.length - 10);
        _alldatetimelast10 = last10datetime.reversed.toList();

        update();

        print('Successfully get AllData');
      } else {
        print('Failedrerer to GetAlldata.');
      }
      return null;
    } catch (e) {
      log(e.toString());
    } finally {}
  }

  Future setwaterpump({
    required bool isActive,
  }) async {
    try {
      final queryParameters = {
        "id": 698633,
        "isactive": isActive,
      };
      final response = await http.post(
        Uri.http('10.10.1.139:88', '/api/channel-data/change-active',
            queryParameters),
      );
      log('Set Water Pump Response ;${response.statusCode}');

      if (response.statusCode == 200) {
        log('Successfully switch water pump');
      } else {
        print('Failedrerer to Getdata.');
      }
      return null;
    } catch (e) {
      print(e.toString());
    }
  }

  void startTimer() {
    _pumpStatus = true;
    setwaterpump(isActive: true);
    NotificationService().showNotification(
        title: 'Water Pump Activated',
        body: 'Water Pump Activated for ${pumptimer ~/ 60} min');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (pumptimer > 0) {
        pumptimer--;

        _min = (pumptimer / 60).floor();
        _sec = pumptimer % 60;
        update();
      } else {
        _timer!.cancel(); // Stop the timer when it reaches 0
        // Add your desired action when the countdown reaches 0 here

        _ismanualwaterconfirm = false;
        setwaterpump(isActive: false);
        _pumpStatus = false;
        _min = 0;
        _sec = 0;
        selectedVisualType.value = null;
        update();
        NotificationService().showNotification(
            title: 'Done', body: '🚰 Water Pump Completed  Successfully');
      }
    });
    _ismanualwaterconfirm = true;
    update();
  }

  void scheduleTask() {
    const Duration interval = Duration(seconds: 30);
    int repeatCount =
        pumptimer ~/ 30; // 5 minutes in seconds divided by 30 seconds interval

    int executionCount = 0;

    Timer.periodic(interval, (Timer timer) {
      if (executionCount < repeatCount) {
        getalldata();

        executionCount++;
      } else {
        timer.cancel();
      }
    });
  }

  //BACKGROUND SERVICES
}
