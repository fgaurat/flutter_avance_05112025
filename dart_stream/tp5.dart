import 'dart:async';

void main() {
  final streamController = StreamController<int>();

  streamController.stream.listen(
      (value) => print("Listener 1 received: $value"),
      onDone: () => print("Listener 1 done"),
      onError: (error) => print("Listener 1 error: $error"));

  streamController.add(1);
  streamController.add(2);
  streamController.add(3);

  streamController.addError("An error occurred!");

  streamController.close();
}
