import 'dart:async';

void main() {
  final streamController = StreamController<int>();

  int counter = 0;

  streamController.stream.listen(
      (value) => print("Listener 1 received: $value"),
      onDone: () => print("Listener 1 done"));

  // streamController.stream.listen(
  //     (value) => print("Listener 1 received: $value"),
  //     onDone: () => print("Listener 1 done"));

  Timer.periodic(Duration(milliseconds: 500), (timer) {
    counter++;
    streamController.sink.add(counter);
    if (counter >= 5) {
      timer.cancel();
      streamController.close();
    }
  });
}
