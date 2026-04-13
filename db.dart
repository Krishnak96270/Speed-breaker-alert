
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'services/db.dart';
import 'services/alert.dart';
import 'services/logic.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double lat = 0, lon = 0;

  bool first = false;
  bool second = false;

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();
    Alert.init();

    Geolocator.getPositionStream().listen((p) async {
      lat = p.latitude;
      lon = p.longitude;

      var points = await DB.getAll();

      for (var pt in points) {
        double d = dist(lat, lon, pt["lat"], pt["lon"]);

        if (d < 60 && !first) {
          Alert.speak("Speed breaker ahead");
          first = true;
        }

        if (d < 20 && !second) {
          Alert.speak("Slow down");
          await Future.delayed(Duration(seconds: 1));
          Alert.speak("Slow down");
          second = true;
        }

        if (d > 80) {
          first = false;
          second = false;
        }
      }

      setState(() {});
    });

    accelerometerEvents.listen((e) async {
      if (e.z > 15) {
        await DB.insert(lat, lon);
        Alert.speak("Saved");
      }
    });
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text("Speed Breaker Alert")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Lat: $lat"),
            Text("Lon: $lon"),
            ElevatedButton(
              onPressed: () async {
                await DB.insert(lat, lon);
              },
              child: Text("Add Manually"),
            )
          ],
        ),
      ),
    );
  }
}
