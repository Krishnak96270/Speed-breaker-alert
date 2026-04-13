import 'package:flutter_tts/flutter_tts.dart';

class AlertService {
  static final tts = FlutterTts();

  static Future init() async {
    await tts.setVolume(1.0);
    await tts.setSpeechRate(0.5);
  }

  static Future speak(String text) async {
    await tts.speak(text);
  }
}
