import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ComentarioDialogConReinicioContent extends StatefulWidget {
  final TextEditingController textController;

  const ComentarioDialogConReinicioContent({super.key, required this.textController});

  @override
  State<ComentarioDialogConReinicioContent> createState() => _ComentarioDialogConReinicioContentState();
}

class _ComentarioDialogConReinicioContentState extends State<ComentarioDialogConReinicioContent> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isInitializing = false; 
  bool _speechAvailable = false;
  
  // Flag crucial para obligar a la app a reactivar el micrófono de forma continua
  bool _shouldBeListening = false; 
  String _oldText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  @override
  void dispose() {
    // Apaga el micrófono de manera forzada y desactiva el bucle para evitar fugas de memoria
    _shouldBeListening = false;
    _speech.stop();
    super.dispose();
  }

  void _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onError: (val) {
        print('Error dictado (Reinicio Activo): $val');
        if (mounted) {
          if (_shouldBeListening) {
            _restartListening();
          } else {
            setState(() {
              _isListening = false;
              _isInitializing = false;
            });
          }
        }
      },
      onStatus: (status) {
        print('Estado dictado (Reinicio Activo): $status');
        if (status == 'notListening' || status == 'done') {
          if (mounted) {
            if (_shouldBeListening) {
              // El SO apagó el micrófono por pausa de voz, forzamos la reactivación
              _restartListening();
            } else {
              setState(() {
                _isListening = false;
                _isInitializing = false;
              });
            }
          }
        } else if (status == 'listening') {
          if (mounted) {
            setState(() {
              _isListening = true;
              _isInitializing = false; 
            });
          }
        }
      },
    );
    if (mounted) setState(() {});
  }

  void _startListening() async {
    if (_speechAvailable) {
      setState(() {
        _isInitializing = true; 
      });

      _oldText = widget.textController.text;
      if (_oldText.isNotEmpty && !_oldText.endsWith(" ")) {
        _oldText += " ";
      }

      await _speech.listen(
        localeId: 'es_ES',
        listenMode: stt.ListenMode.dictation,
        cancelOnError: false,
        onResult: (val) {
          setState(() {
            widget.textController.text = '$_oldText${val.recognizedWords}';
            widget.textController.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.textController.text.length),
              );
          });
        },
      );
    }
  }

  void _listen() async {
    if (!_isListening) {
      _shouldBeListening = true;
      _startListening();
    } else {
      _shouldBeListening = false;
      await _speech.stop();
      if (mounted) {
        setState(() {
          _isListening = false;
          _isInitializing = false;
        });
      }
    }
  }

  void _restartListening() async {
    if (_shouldBeListening && mounted) {
      // Retraso técnico necesario para que el controlador de audio móvil se libere
      await Future.delayed(const Duration(milliseconds: 350));
      if (_shouldBeListening && mounted && !_speech.isListening) {
        _startListening();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: widget.textController,
          maxLines: null,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: 'Escriba su comentario...',
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 8),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_isInitializing)
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Iniciando...",
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            else if (_isListening)
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Hable ahora...",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            else
              const SizedBox.shrink(), 

            Material(
              color: (_isListening || _isInitializing) 
                  ? Colors.red.withOpacity(0.1) 
                  : Colors.grey[100],
              shape: const CircleBorder(),
              child: IconButton(
                icon: Icon(
                  (_isListening || _isInitializing) ? Icons.mic : Icons.mic_none,
                  color: (_isListening || _isInitializing) ? Colors.red : Colors.blueGrey,
                ),
                onPressed: _speechAvailable ? _listen : null,
                tooltip: 'Dictar comentario por voz',
              ),
            ),
          ],
        ),
      ],
    );
  }
}