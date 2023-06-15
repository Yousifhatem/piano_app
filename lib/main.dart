import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterMidi flutterMidi = FlutterMidi();
  String choice = 'Guitars';
  Uri? link;

  @override
  void initState() {
    load('assets/$choice.sf2');
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);
    flutterMidi.prepare(
        sf2: byte, name: 'assets/$choice.sf2'.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: const Text(
        //   'Piano App',
        //   style: TextStyle(
        //       color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        // ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: DropdownButton<String?>(
            dropdownColor: Colors.deepOrange,
            value: choice,
            items: const [
              DropdownMenuItem(
                value: 'Guitars',
                child: Text(
                  'Guitars',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              DropdownMenuItem(
                value: 'Strings',
                child: Text(
                  'Strings',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              DropdownMenuItem(
                value: 'Yamaha-Grand',
                child: Text(
                  'Piano',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                choice = value.toString();
              });
              load('assets/$choice.sf2');
            },
          ),
        ),
        leadingWidth: 125,
        actions: [
          IconButton(
            onPressed: () {
              link = Uri.parse('tel:0597764210');
              launchUrl(link!);
            },
            icon: const Icon(
              Icons.call,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              link = Uri.parse('sms:0597764210');
              launchUrl(link!);
            },
            icon: const Icon(
              Icons.sms,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              link = Uri.parse('mailto:yousifhatem1@gmail.com');
              launchUrl(link!);
            },
            icon: const Icon(
              Icons.email,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              link = Uri.parse('https://google.ps');
              launchUrl(link!, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [
            NotePosition(note: Note.C, octave: 3),
          ],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 60,
          noteRange: NoteRange.forClefs([
            Clef.Treble,
          ]),
          onNotePositionTapped: (position) {
            flutterMidi.playMidiNote(midi: position.pitch);
          },
        ),
      ),
    );
  }
}
