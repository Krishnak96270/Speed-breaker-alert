import 'package:sensors_plus/sensors_plus.dart';

class DetectionService {
  static void start(Function onDetect) {
    accelerometerEvents.listen((e) {
      if (e.z > 15) onDetect();
    });
  }
}
