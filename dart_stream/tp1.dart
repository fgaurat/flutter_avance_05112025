void main() {
  print("Hello, Dart!");
  var arr = [1, 2, 3, 4, 5];
  var stream = Stream.fromIterable(arr);

  stream.listen((value) {
    print("Stream value: $value");
  }, onDone: () {
    print("Stream is done.");
  });
}
