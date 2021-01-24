import 'dart:async';

// broadcast is used for allowing to listen to stream from more than one source (multiple times)
StreamController<int> _controller = StreamController<int>.broadcast();
Stream<int> get out => _controller.stream;
main() {
  out.listen((i) => print(i + 2));
  out.listen((event) => print(event));

  for (int i = 1; i <= 3; i++) {
    _controller.sink.add(i);
  }
}
