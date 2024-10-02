import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //SpechToText
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnebled = false;
  String _wordsSpoken = '';
  double _confidenceLevel = 0;

  //TextToSpeech
  FlutterTts _flutterTts = FlutterTts();
  List<Map> _voices = [];
  Map? _currentVoice;
  String TTS_INPUT = 'Este código toma una cadena de texto (TTS_INPUT) y resalta un segmento específico de la misma. La parte anterior y posterior al segmento resaltado se muestra con el estilo predeterminado (negro, fuente ligera), mientras que el segmento resaltado se muestra con un color de fondo púrpura y texto blanco. Esto podría ser útil, por ejemplo, en una aplicación que resalta palabras mientras se lee en voz alta, o para mostrar visualmente la palabra actual que está siendo pronunciada por un sistema de texto a voz (TTS).';
  int? _currentWordStart, _currentWordEnd;

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTTS();
  }

  //Inicio SpeechToText
  void initSpeech() async {
    _speechEnebled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    _confidenceLevel = 0;
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = '${result.recognizedWords}';
      _confidenceLevel = result.confidence;
    });
  }
  //Fin SpeechToText

  //Inicio TextToSpeech
  void initTTS() {
    _flutterTts.setProgressHandler((text,start,end,word){
      setState(() {
        _currentWordStart = start;
        _currentWordEnd = end;
      });
    });

    //Recorre cada una de las voces y los va almacenando en una lista
    _flutterTts.getVoices.then((data) {
      try {
        _voices = List<Map>.from(data);
        setState(() {
          //filtra por idioma
          _voices =
              _voices.where((_voice) => _voice["name"].contains("es")).toList();
          _currentVoice = _voices.first;
          setVoice(_currentVoice!);
        });
      } catch (e) {
        print('Error en TTS: $e');
      }
    });
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  //Fin TextToSpeech

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Speech Demo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Linstening..."
                    : _speechEnebled
                        ? "Tap the microphone to start listening..."
                        : "Speech not available",
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _wordsSpoken,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),

            //Widget de Text To Speech
            _buildUI(),

            if (_speechToText.isNotListening && _confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  'Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: Stack(children: [
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed:
                _speechToText.isListening ? _stopListening : _startListening,
            tooltip: 'Listen',
            backgroundColor: Colors.red,
            child: Icon(
              _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          bottom: 80.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              _flutterTts.speak(TTS_INPUT);
            },
            tooltip: 'Listen',
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.speaker_phone,
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _speakerSelector(),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
              color: Colors.black
            ),
            children: <TextSpan>[
              TextSpan(
                text: TTS_INPUT.substring(0, _currentWordStart),
              ),
              if(_currentWordStart != null)
                TextSpan(
                  text: TTS_INPUT.substring(_currentWordStart!, _currentWordEnd),
                  style: const TextStyle(
                    color: Colors.white,
                    backgroundColor: Colors.purpleAccent,
                  )
                ),
              if(_currentWordStart != null)
                TextSpan(
                  text: TTS_INPUT.substring(_currentWordEnd!),
                ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _speakerSelector() {
    return DropdownButton(
        value: _currentVoice,
        items: _voices.map((_voice) => DropdownMenuItem(
                value: _voice,
                child: Text(
                  _voice["name"],
                ),
              ),
            ).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            setState(() {
              _currentVoice = newValue;
              setVoice(_currentVoice!);
            });
          }
        },
    );
  }
}
