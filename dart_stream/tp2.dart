void main() {
  var arr = [1, 2, 3, 4, 5];
  var stream = Stream.fromIterable(arr);

  stream.where((n) => n.isEven).map((event) {
    return event * 10;
  }).listen((value) {
    print("Received: $value");
  }, onDone: () {
    print("All values received.");
  });
}
