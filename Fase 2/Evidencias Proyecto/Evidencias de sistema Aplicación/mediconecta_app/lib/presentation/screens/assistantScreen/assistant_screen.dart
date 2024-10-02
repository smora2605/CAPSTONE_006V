import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconecta_app/nlp/nlp.dart';
import 'package:mediconecta_app/theme/theme.dart';
import 'package:mediconecta_app/widgets/animations/microphone_button.dart';
import 'package:mediconecta_app/widgets/availability_list_widget.dart';
import 'package:mediconecta_app/widgets/doctor_list_widget.dart';
import 'package:mediconecta_app/widgets/summary_cita_card.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  // Speech-to-Text
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _wordsSpoken = '';
  // double _confidenceLevel = 0;
  bool _isListening = false;

  // Text-to-Speech
  FlutterTts _flutterTts = FlutterTts();
  String _ttsInput = '';
  // Map? _currentVoice;
  bool _isSpeaking = false; // Estado para saber si está hablando

  //Mostrar info como widget
  bool _showDoctorList = false;
  bool _showSpecialtyList = false;
  bool _showTurnList = false;
  bool _showAvailabilityList = false;
  bool _showSummaryList = false;
  bool _showCreadtedSuccessfully = false;

  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _specialties = [];
  List<Map<String, dynamic>> _availability = [];
  List<dynamic> _turno = [];
  Map<String, dynamic> _summary = {};
  List<dynamic> _createdSuccessfully = [];
  
  String? selectedDoctor;
  String? selectedDoctorName;
  int? selectedDoctorIndex;
  String? selectedAvailability;
  String? selectedHour;
  int? selectedAvailabilityIndex;

  final String mensajeInicial = 'Hola Eduardo, ¿Cómo estás?, ¿En qué puedo ayudarte?';

  final NLP _nlp = NLP();

  void _handleDoctorSelected(int index) {
    setState(() {
      selectedDoctorIndex = index;
      final doctor = _doctors[index];
      selectedDoctor = '${doctor['nombre']} - ${doctor['especialidad']}';
      selectedDoctorName = '${doctor['nombre']}';
      print('selectedDoctor$selectedDoctor');
    });
    //Algo ocurre que por voz no puedo eejcutarlo
    _flutterTts.speak(selectedDoctor!);
  }

  void _handleAvailabilitySelected(int horaIndex) {
    setState(() {
      selectedAvailabilityIndex = horaIndex;
      final hour = _availability[horaIndex];
      print('hour $hour');
      selectedAvailability = '${hour['hora']}}';
      selectedHour = '${hour['hora']}';
      print('selectedAvailability $selectedAvailability');
    });
    _flutterTts.speak('$selectedAvailability');
  }

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTTS();
    // _loadDoctors();
    _flutterTts.speak(mensajeInicial);
    setState(() {
      _ttsInput = mensajeInicial;
    });
  }
  
  void initSpeech() async {
    //Se gatilla al darle click en el microfono pero cuando el user deja de hablar el status pasa a done y comienza a generarse la respuesta
    if (!_speechEnabled) {
      _speechEnabled = await _speechToText.initialize(onStatus: _onSpeechStatus);
      setState(() {});
    }
  }

  void _onSpeechStatus(String status) {
    print('status $status');
    if (status == "done") {
      _processUserInput(_wordsSpoken);
      setState(() {
        _isListening = false;
      });
    }
  }

  void initTTS() {
    _flutterTts.setVoice({"name": "es-us-x-sfb-local", "locale": "es-US"});

    _flutterTts.setStartHandler(() {
      setState(() {
        print('hablando');
        _isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
    });
  
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    print('IsListening');
    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    print('StopListening');
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  //Genera la consulta en texto del usuario
  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      // _confidenceLevel = result.confidence;
    });
  }

  void _processUserInput(String input) async {
    try {
      Map<String, dynamic> response = await _nlp.generateResponse(input);

      // La respuesta se muestra en texto y se convierte en voz
      String formattedResponse = response['formattedResponse'];
      _ttsInput = formattedResponse;
      setState(() {});
      _flutterTts.speak(_ttsInput);

      // Actualizar el estado según el tipo de datos en 'rawData'
      if (response.containsKey('rawData')) {
        var rawData = response['rawData'];
        print('rawData $rawData');


        if (rawData is List) {
          // Asumimos que rawData puede ser una lista de doctores, especialidades, etc.
          if (rawData.isNotEmpty) {
            // Verificar el tipo de datos
            if (rawData.first is Map<String, dynamic>) {
              var firstItem = rawData.first;
              print('firstItem $firstItem');
              
              if (firstItem.containsKey('nombre')) {
                // Es una lista de doctores
                setState(() {
                  _doctors = List<Map<String, dynamic>>.from(rawData);
                  _showDoctorList = true;
                  _showSpecialtyList = false;
                  _showTurnList = false;
                  _showAvailabilityList = false;
                  _showSummaryList = false;
                  _showCreadtedSuccessfully = false;
                });
              } else if (firstItem.containsKey('especialidad')) {
                // Es una lista de especialidades
                setState(() {
                  _specialties = List<Map<String, dynamic>>.from(rawData);
                  _showDoctorList = false;
                  _showSpecialtyList = true;
                  _showTurnList = false;
                  _showAvailabilityList = false;
                  _showSummaryList = false;
                  _showCreadtedSuccessfully = false;
                });
              } else if (firstItem.containsKey('turno')) {
                // Es una lista de especialidades
                setState(() {
                  _turno = List<Map<String, dynamic>>.from(rawData);
                  _showDoctorList = false;
                  _showSpecialtyList = false;
                  _showTurnList = true;
                  _showAvailabilityList = false;
                  _showSummaryList = false;
                  _showCreadtedSuccessfully = false;
                });
              }
              else if (firstItem.containsKey('hora')) {
                // Es una lista de horarios disponibles
                setState(() {
                  _availability = List<Map<String, dynamic>>.from(rawData);
                  _showDoctorList = false;
                  _showSpecialtyList = false;
                  _showTurnList = false;
                  _showAvailabilityList = true;
                  _showSummaryList = false;
                  _showCreadtedSuccessfully = false;
                });
              }
              else if (firstItem.containsKey('TipoResumen')) {
                // Es una lista de horarios disponibles
                setState(() {
                  if (rawData.isNotEmpty) {
                    _summary = Map<String, dynamic>.from(rawData[0]); // Extraer el primer elemento de la lista como Map
                  }
                  _showDoctorList = false;
                  _showSpecialtyList = false;
                  _showTurnList = false;
                  _showAvailabilityList = false;
                  _showSummaryList = true;
                  _showCreadtedSuccessfully = false;
                  print('_showSummaryList $_showSummaryList');
                });
              }
              else if (firstItem.containsKey('success')) {
                print('entraEnSuccess');
                // Es una lista de horarios disponibles
                setState(() {
                  if (rawData.isNotEmpty) {
                    _createdSuccessfully = [rawData[0]];
                  }
                  _showDoctorList = false;
                  _showSpecialtyList = false;
                  _showTurnList = false;
                  _showAvailabilityList = false;
                  _showSummaryList = false;
                  _showCreadtedSuccessfully = true;
                  print('_createdSuccessfully $_createdSuccessfully');
                });
              }
            }
          }
        } else {
          // Manejar otros tipos de datos si es necesario
          _showDoctorList = false;
          _showSpecialtyList = false;
          _showTurnList = false;
          _showAvailabilityList = false;
          _showSummaryList = false;
          _showCreadtedSuccessfully = false;
        }
      } else {
        _showDoctorList = false;
        _showSpecialtyList = false;
        _showTurnList = false;
        _showAvailabilityList = false;
        _showSummaryList = false;
        _showCreadtedSuccessfully = false;
      }
      print('_flutterTts $_flutterTts');
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Cancela cualquier operación en curso
    _speechToText.stop(); // Detener el reconocimiento de voz
    _speechToText.cancel(); // Cancelar cualquier operación pendiente
    _flutterTts.stop(); // Detener el TTS

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Column(
          children: [
            // Container top
            Container(
              width: size.width,
              height: size.height / 1.2,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_wordsSpoken.isNotEmpty)
                      Text(
                        'Tú: $_wordsSpoken',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 20),
                    
                    _showDoctorList
                        ? Expanded(
                            child: DoctorListWidget(
                              doctors: _doctors,
                              onDoctorSelected: _handleDoctorSelected,
                              selectedDoctorIndex: selectedDoctorIndex,
                            ),
                          )
                        : _showTurnList
                            ? Column(
                              children: [
                                const Text(
                                  'Selecciona el bloque horario',
                                  style: TextStyle(
                                    color: AppColors.textColorDark,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _turno.map((e) => 
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Aquí puedes manejar la acción del botón
                                              _processUserInput(e['turno']);
                                            },
                                            child: Text(
                                              '${e['turno']}',
                                              style: const TextStyle(
                                                color: AppColors.textColorDark,
                                                fontSize: 18,
                                              ),
                                            ), // Asegúrate de que 'turno' es una propiedad de los elementos en _turno
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).toList(),
                                ),
                              ],
                            )
                            : _showAvailabilityList
                                ? Expanded(
                                    child: AvailabilityListWidget(
                                      availability: _availability,
                                      onAvailabilitySelected: _handleAvailabilitySelected,
                                      selectedAvailabilityIndex: selectedAvailabilityIndex,
                                    ),
                                  )
                                  : _showSummaryList
                                    ? Expanded(
                                      child: SummaryCitaCard(
                                        summaryCita: _summary,
                                      ),
                                    )
                                    : Text(
                                        _ttsInput,
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),

                    const SizedBox(height: 40),
                    Text(
                      _speechToText.isListening
                          ? "Escuchando..."
                          : _speechEnabled
                              ? "Toca el micrófono para empezar a hablar o selecciona uno de los botones acá abajo."
                              : "Reconocimiento de voz no disponible.",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    //Buttons
                    // Mostrar los botones solo si ninguna de las variables es true
                    if (!(_showDoctorList || _showSpecialtyList || _showAvailabilityList || _showSummaryList || _showTurnList || _showCreadtedSuccessfully))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Botón de Medicina General
                          ElevatedButton(
                            onPressed: () {
                              _processUserInput('Medicina general');
                            },
                            child: const Text(
                              'Medicina general',
                              style: TextStyle(
                                color: AppColors.textColorDark,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          // Botón de Cardiología
                          ElevatedButton(
                            onPressed: () {
                              _processUserInput('Cardiología');
                            },
                            child: const Text(
                              'Cardiología',
                              style: TextStyle(
                                color: AppColors.textColorDark,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),

                    if (_showDoctorList)
                      ElevatedButton(
                        onPressed: () {_processUserInput(selectedDoctorName!);},
                        child: const Text(
                          'Seleccionar doctor',
                          style: TextStyle(
                              color: AppColors.textColorDark,
                              fontSize: 18,
                          ),
                        )
                      ),

                    if (_showAvailabilityList)
                      ElevatedButton(
                        onPressed: () {_processUserInput(selectedHour!);},
                        child: const Text(
                          'Seleccionar hora',
                          style: TextStyle(
                              color: AppColors.textColorDark,
                              fontSize: 18,
                          ),
                        )
                      ),

                    if (_showSummaryList)
                      ElevatedButton(
                        onPressed: () {_processUserInput('confirmar');},
                        child: const Text(
                          'Confirmar cita',
                          style: TextStyle(
                              color: AppColors.textColorDark,
                              fontSize: 18,
                          ),
                        )
                      ),

                    if (_showCreadtedSuccessfully)
                      ElevatedButton(
                        onPressed: () {context.go('/');},
                        child: const Text(
                          'Volver',
                          style: TextStyle(
                              color: AppColors.textColorDark,
                              fontSize: 18,
                          ),
                        )
                      ),
                  ],
                ),
              ),
            ),

            // Container bottom
            Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
              ),
              height: size.height / 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _flutterTts.stop,
                    child: Icon(
                      _isSpeaking ? Icons.volume_up : Icons.volume_off,
                      size: 35,
                    ),
                  ),
                  MicrophoneButton(
                    isListening: _isListening,
                    startListening: _startListening,
                    stopListening: _stopListening,
                  ),
                  GestureDetector(
                    onTap: () {
                      _processUserInput(_wordsSpoken);
                    },
                    child: Icon(
                      _isSpeaking ? Icons.stop : Icons.play_arrow,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
