import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const CHANNEL = 'it.pixeldump.pocs.fluttermakesomenoise';
  static const platformChannel = const MethodChannel(CHANNEL);

  bool _playState = false;
  String _currentWaveform = 'sine';
  String _currentNoteName = 'A';

  List<String> waveForms = [
    'sine',
    'sawTooth',
    'square',
  ];

  List<String> noteNames = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G',
  ];

  // A4 - B5
  List<double> frequencies = [
    440.0, 493.88, 523.25, 587.33, 659.25, 698.46, 783.99,
  ];

  @override
  void initState() {
    super.initState();
    platformChannel.invokeMethod('setFrequency', {'frequency': frequencies[0]});
  }

  void _updateCurrentNote(){
    int pos = noteNames.indexOf(_currentNoteName);
    platformChannel.invokeMethod('setFrequency', {'frequency': frequencies[pos]});
  }

  void _playSound(){
    platformChannel.invokeMethod('play');
    setState(() {
      _playState = true;
    });
  }

  void _stopSound(){
    platformChannel.invokeMethod('stop');
    setState(() {
      _playState = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: new Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: new AppBar(
          title: const Text(
            'Flutter, make some noise demo',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new Spacer(),
              new ClipOval(
                child: Container(
                  color: Colors.blue,
                  child: IconButton(
                      icon: _playState ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                      tooltip: 'play/stop',
                      color: Colors.white,
                      onPressed: () {
                        if(_playState) _stopSound();
                        else _playSound();
                      }
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(left: 64.0, right: 64.0, top: 32.0),
                child: new ListTile(
                  title: const Text('note name:'),
                  trailing: new DropdownButton<String>(
                    value: _currentNoteName,
                    onChanged: (String newValue) {
                      setState(() {
                        _currentNoteName = newValue;
                        _updateCurrentNote();
                      });
                    },
                    items: noteNames.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.only(left: 64.0, right: 64.0),
                child: new ListTile(
                  title: const Text('wave form:'),
                  trailing: new DropdownButton<String>(
                    value: _currentWaveform,
                    onChanged: (String newValue) {
                      setState(() {
                        _currentWaveform = newValue;
                        platformChannel.invokeMethod('setWaveform', {'waveform': newValue});
                      });
                    },
                    items: waveForms.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              new Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}