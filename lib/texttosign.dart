import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'signtotext.dart';
import 'tutorials.dart';
import 'homescreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TextToSignScreen extends StatefulWidget {
  const TextToSignScreen({Key? key}) : super(key: key);

  @override
  _TextToSignScreenState createState() => _TextToSignScreenState();
}

class _TextToSignScreenState extends State<TextToSignScreen> {
  final TextEditingController _textController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _translatedSign = '';
  Timer? _inactivityTimer;
  int _selectedIndex = 1;

  void _translateToSign(String text) {
    // TODO: Implement the translation logic
    setState(() {
      _translatedSign = 'Translated sign for: $text are here';
    });
  }

  void _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speechToText.listen(onResult: (result) {
        setState(() {
          _textController.text = result.recognizedWords;
          _translateToSign(result.recognizedWords);
        });
        _resetInactivityTimer();
      });
      _resetInactivityTimer();
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
    _inactivityTimer?.cancel();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 2), () {
      if (_isListening) {
        _stopListening();
      }
    });
  }

  void _translateTypedText() {
    _translateToSign(_textController.text);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        _navigateToScreen(const HomeScreen());
        break;
      case 1:
        _navigateToScreen(const TextToSignScreen());
        break;
      case 2:
        _navigateToScreen(const SignToTextScreen());
        break;
      case 3:
        _navigateToScreen(const TutorialsScreen());
        break;
    }
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Sign'),
        automaticallyImplyLeading: false,
      ),
      body: WebView(
        initialUrl: 'https://a5fe-2409-40c0-10-af36-1cb5-45c7-68f9-1c03.ngrok-free.app',
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text to Sign',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gesture),
            label: 'Sign to Text',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Tutorials',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor:
            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
        onTap: _onItemTapped,
      ),
    );
  }
}
