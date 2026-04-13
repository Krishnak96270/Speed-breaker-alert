import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../services/location_service.dart';
import '../services/db_helper.dart';
import '../services/detection_service.dart';
import '../services/alert_service.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double lat = 0;
  double lon = 0;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    AlertService.init();

    LocationService.getPositionStream().listen((pos) {
      lat = pos.latitude;
      lon = pos.longitude;
      setState(() {});
    });

    DetectionService.start(() async {
      await DBHelper.insert(lat, lon);
      AlertService.speak("Speed breaker detected");
    });
  }

  void addManual() async {
    await DBHelper.insert(lat, lon);
    AlertService.speak("Saved manually");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speed Breaker Alert")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Lat: $lat"),
          Text("Lon: $lon"),
          SizedBox(height: 20),
          ElevatedButton(onPressed: addManual, child: Text("Add")),
        ],
      ),
    );
  }
}
