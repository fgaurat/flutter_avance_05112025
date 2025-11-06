void main() async {
  final stream = Stream.periodic(Duration(milliseconds: 500), (count) => count);

  final subscription = stream.listen((value) {
    print("Stream emitted: $value");
  });

  await Future.delayed(Duration(milliseconds: 1200));
  subscription.pause();
  print("Stream paused");

  await Future.delayed(Duration(milliseconds: 2000));
  subscription.resume();
  print("Stream resumed");

  await Future.delayed(Duration(milliseconds: 4000));
  subscription.cancel();
}
