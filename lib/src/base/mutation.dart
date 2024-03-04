import 'dart:async';
import 'package:fuery_core/src/fuery_client.dart';
import 'package:fuery_core/src/util/garbage_collector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/mutation_options.dart';
import 'package:fuery_core/src/mutation_state.dart';

abstract class MutationBase<Args, Data, Err, State extends MutationState<Data, Err>> with GarbageCollector {
  MutationBase({
    required MutationKey mutationKey,
    MutationOptions<Args, Data, Err>? options,
  })  : _mutationKey = mutationKey,
        _options = options ?? MutationOptions(),
        _state = MutationState<Data, Err>() as State;

  final MutationKey _mutationKey;
  MutationKey get mutationKey => _mutationKey;

  MutationOptions<Args, Data, Err> _options;
  MutationOptions<Args, Data, Err> get options => _options;

  State _state;

  BehaviorSubject<State>? _subject;

  void _setGcTimer() {
    super.setGcTimer(
      gcTime: _options.gcTime,
      callback: () => Fuery.instance.removeMutation(mutationKey),
    );
  }

  void _cancelGcTimer() {
    if (hasListener) super.cancelGcTimer();
  }

  void emit(State state) {
    _state = state;
    _subject?.add(_state);
  }

  void setArguments(Args arguments) {
    _options = _options.copyWith(arguments: () => arguments);
  }

  void wake() {
    if (_subject != null) return;

    _subject = BehaviorSubject.seeded(_state)
      ..onListen = _cancelGcTimer
      ..onCancel = sleep;
  }

  Future<void> sleep() async {
    await _subject?.close();
    _subject = null;
    _setGcTimer();
  }

  ValueStream<State> get stream {
    wake();
    return _subject!.stream;
  }

  bool get hasListener => _subject?.hasListener ?? false;
}
