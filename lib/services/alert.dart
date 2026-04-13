
import 'package:flutter_tts/flutter_tts.dart';

class Alert {
  static final tts = FlutterTts();

  static init() async {
    await tts.setVolume(1);
    await tts.setSpeechRate(0.5);
  }

  static speak(String msg) async {
    await tts.speak(msg);
  }
}
