import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  final FlutterTts _flutterTts = FlutterTts();
  Function? _completionHandler;

  TTSHelper() {
    _flutterTts.setCompletionHandler(() {
      if (_completionHandler != null) {
        _completionHandler!();
      }
    });
  }

  void setCompletionHandler(Function handler) {
    _completionHandler = handler;
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    if (_completionHandler != null) {
      _completionHandler!();
    }
  }
}