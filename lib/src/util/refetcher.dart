import 'dart:async';

mixin Refetcher {
  Timer? _timer;

  void setRefetchTimer({
    required int interval,
    required void Function() callback,
  }) {
    _timer ??= Timer.periodic(
      Duration(milliseconds: interval),
      (_) => callback(),
    );
  }

  void cancelRefetchTimer() {
    if (hasRefetchTimer) {
      _timer?.cancel();
      _timer = null;
    }
  }

  bool get hasRefetchTimer => _timer is Timer;
}
