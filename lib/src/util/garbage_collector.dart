import 'dart:async';

mixin GarbageCollector {
  Timer? _timer;

  void setGcTimer({
    required int gcTime,
    required void Function() callback,
  }) {
    _timer ??= Timer(
      Duration(milliseconds: gcTime),
      callback,
    );
  }

  void cancelGcTimer() {
    if (hasGcTimer) {
      _timer?.cancel();
      _timer = null;
    }
  }

  bool get hasGcTimer => _timer is Timer;
}
