import 'dart:async';  // Add this import for StreamController
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AashaScreen extends StatefulWidget {
  const AashaScreen({super.key});

  @override
  State<AashaScreen> createState() => _AashaScreenState();
}

class _AashaScreenState extends State<AashaScreen> {
  final record = AudioRecorder();
  final player = FlutterSoundPlayer();
  bool isRecording = false;
  // Stream<Uint8List>? stream;
  // List<int> audioBytes = [];
  String audioFile = "";

  Future<String> getDownloadsPath() async {
    final directory = await getDownloadsDirectory();
    return directory?.path ?? '';
  }


  // Start recording and store the audio in memory as bytes
  Future<void> _startRecording() async {
    if (await record.hasPermission()) {
      audioFile = "${await getDownloadsPath()}/saathi.wav";
      await record.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: audioFile
      );
      
      setState(() {
        isRecording = true;
      });
      print("Recording started ...");
    }
  }

  // Stop recording and handle the audio data
  Future<void> _stopRecording() async {
    if (isRecording) {
      await record.stop();
      print("Recording stopped ...");

      setState(() {
        isRecording = false;
      });

      await uploadFile();
    } else {
      print("Not recording rn");
    }
  }

  Future<void> uploadFile() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie == null) {
      return;
    }

    var request = http.MultipartRequest(
      'POST', 
      // Uri.parse(
      //   'https://e566-14-139-185-115.ngrok-free.app/child/gemini/voice_chat'
      // )
      Uri.parse("${dotenv.env['BASE_URL']}/child/voice_chat")
    );
    request.headers['Content-Type'] = 'application/json';
    request.headers['Cookie'] = sessionCookie;

    request.files.add(await http.MultipartFile.fromPath('file', audioFile));
    var response = await request.send();

    print('${response.headers}');

    File f = File(audioFile);
    await f.writeAsBytes(await response.stream.toBytes());

    await player.openPlayer();
    await player.startPlayer(fromURI: audioFile, whenFinished: () {
      print("Finished playing response audio");
      player.closePlayer();
    });
  }

  Future<void> endCall() async {
    final prefs = await SharedPreferences.getInstance();
    String? sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie == null) {
      return;
    }

    http.post(
      Uri.parse("${dotenv.env['BASE_URL']}/child/end_chat"),
      headers: {'Content-Type': 'application/json', 'Cookie': sessionCookie},
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xCC45392F), Color(0x00C78D53)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(16),
              child: Text(
                "Aasha", 
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              )
            ),
            Expanded(
              // child: Center(
                child: GestureDetector(
                  onLongPress: _startRecording,
                  onLongPressUp: _stopRecording,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red : Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRecording ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              // )
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.21,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(110)), 
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFCCAC6), Color(0xFFF2B662)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight
                        )
                      ),
                    )
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: endCall,
                      child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle
                      ),
                      child: Icon(Icons.call_end, color: Colors.white, size: 40)
                    ))
                  )
                ]
              )
            )
          ]
        ),
      )
    ));
  }
}
