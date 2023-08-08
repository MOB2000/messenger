import 'dart:async' show Timer;
import 'dart:ui' show VoidCallback;

class DeBouncer {
  final int milliseconds;
  Timer? _timer;

  DeBouncer({
    required this.milliseconds,
  });

  run(VoidCallback action) {
    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
