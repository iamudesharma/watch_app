import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        visualDensity: VisualDensity.compact,
        useMaterial3: true, // use material 3
        colorScheme: const ColorScheme.dark(
          // dark colorscheme
          primary: Colors.white24,
          onBackground: Colors.white10,
          onSurface: Colors.white10,
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Wear wear = Wear();

  @override
  void initState() {
    super.initState();
  }

  final raw = 3000; // 3sec

  DateFormat dateFormat = DateFormat.Hms();

  final stopWatchTimer =
      StopWatchTimer(mode: StopWatchMode.countUp, presetMillisecond: 10);

  @override
  Widget build(BuildContext context) {
    print('build');
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: WatchShape(
        builder: (BuildContext context, WearShape shape, Widget? child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                child!,
              ],
            ),
          );
        },
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Stopwatch",
            ),
            TimeWidget(dateFormat: dateFormat),
            SizedBox(height: 10),
            StreamBuilder<int>(
              stream: stopWatchTimer.rawTime,
              initialData: 0,
              builder: (context, snap) {
                final value = snap.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!);
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        displayTime,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      stopWatchTimer.onStartTimer();
                    },
                    child: Icon(Icons.play_arrow)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeWidget extends StatefulWidget {
  const TimeWidget({
    super.key,
    required this.dateFormat,
  });

  final DateFormat dateFormat;

  @override
  State<TimeWidget> createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  DateFormat dateFormat = DateFormat.Hms();

  @override
  Widget build(BuildContext context) {
    return Text(
      dateFormat.format(DateTime.now().toLocal()),
    );
  }
}
