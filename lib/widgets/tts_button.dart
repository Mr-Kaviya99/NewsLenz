import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSButton extends StatelessWidget {
  final String text;

  TTSButton({required this.text});

  @override
  Widget build(BuildContext context) {
    final FlutterTts flutterTts = FlutterTts();

    return IconButton(
      icon: Icon(Icons.play_arrow),
      onPressed: () async {
        await flutterTts.speak(text);
      },
    );
  }
}
