import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MaterialApp(
    home: SpeechScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.red,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  double _confidence = 1.0;
  String _text = 'Press the button and start speaking';

  final Map<String, HighlightedWord> _map = {
    'Yusuf': HighlightedWord(
        onTap: () => print('yusuf'),
        textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    'Lukman': HighlightedWord(
        onTap: () => print('lukman '),
        textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    'Zahro': HighlightedWord(
        onTap: () => print('zahro'),
        textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    'Jannah': HighlightedWord(
        onTap: () => print('jannah'),
        textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    'Zulfa': HighlightedWord(
        onTap: () => print('zulfa'),
        textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (i) => print('onStatus : $i'),
        onError: (i) => print('onErorr : $i'),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
            onResult: (i) => setState(() {
                  _text = i.recognizedWords;
                  if (i.hasConfidenceRating && i.confidence > 0) {
                    _confidence = i.confidence;
                  }
                }));
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Speech'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 60,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(microseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: EdgeInsets.all(30),
            child: TextHighlight(
              text: _text,
              words: _map,
              textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            )),
      ),
    );
  }
}
