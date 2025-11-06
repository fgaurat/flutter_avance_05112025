import 'dart:async';

void main() {
  // cold stream => rejouer toutes les datas
  // hot stream => émet en temps réel

  // cold();
  hot();
}

void cold() async {
  var arr = [1, 2, 3, 4, 5];
  var coldStream = Stream.fromIterable(arr);

  coldStream.listen((value) {
    print("Listener 1 received: $value");
  });

  coldStream.listen((value) {
    print("Listener 2 received: $value");
  });

  await Future.delayed(Duration(seconds: 1));
  print("Adding Listener 3 after delay");
  coldStream.listen((value) {
    print("Listener 3 received: $value");
  });
}

void hot() async {
  final controller = StreamController<int>.broadcast();
  int counter = 0;
  Timer.periodic(Duration(milliseconds: 500), (timer) {
    controller.add(counter);
    counter++;
    if (counter >= 5) {
      timer.cancel();
      controller.close();
    }
  });

  controller.stream.listen((value) {
    print("Listener 1 received: $value");
  });

  await Future.delayed(Duration(milliseconds: 1200));

  controller.stream.listen((value) {
    print("Listener 2 received: $value");
  });
}
