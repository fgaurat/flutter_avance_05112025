import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  heavyWorkOffMain2() => compute(_heavyFn, 200);

  _heavyFn(int milliseconds) {
    final stopWatch = Stopwatch()..start();
    while (stopWatch.elapsedMilliseconds < milliseconds) {
      // print('Doing heavy work in heavyWorkOffMain2...');
    }
    stopWatch.stop();
  }

  heavyWorkOffMain1() {
    return Isolate.run(() {
      final stopWatch = Stopwatch()..start();
      while (stopWatch.elapsedMilliseconds < 200) {
        // print('Doing heavy work in heavyWorkOffMain1...');
      }
      stopWatch.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                final stopWatch = Stopwatch()..start();
                while (stopWatch.elapsedMilliseconds < 200) {
                  // print('Doing heavy work...');
                }
                stopWatch.stop();
              },
              child: Text('Heavy work'),
            ),
            ElevatedButton(
              onPressed: () async {
                await heavyWorkOffMain1();
              },
              child: Text('Heavy work isolate'),
            ),
            ElevatedButton(
              onPressed: () async {
                await heavyWorkOffMain2();
              },
              child: Text('Heavy work compute'),
            ),
          ],
        ),
      ),
    );
  }
}
