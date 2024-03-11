import 'dart:async';
import 'package:fuery_core/src/base/cacheable.dart';
import 'package:fuery_core/src/fuery_client.dart';
import 'package:fuery_core/src/util/garbage_collector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/mutation_options.dart';
import 'package:fuery_core/src/mutation_state.dart';

abstract class MutationBase<Params, Data, Err,
        State extends MutationState<Data, Err>> extends Cacheable
    with GarbageCollector {
  MutationBase({
    required MutationKey mutationKey,
    MutationOptions<Params, Data, Err>? options,
  })  : _options = options ?? MutationOptions(),
        _state = MutationState<Data, Err>() as State,
        super(key: mutationKey);

  MutationOptions<Params, Data, Err> _options;
  MutationOptions<Params, Data, Err> get options => _options;

  State _state;

  BehaviorSubject<State>? _subject;

  void _setGcTimer() {
    super.setGcTimer(
      gcTime: _options.gcTime,
      callback: () => Fuery.instance.removeMutation(key),
    );
  }

  void _cancelGcTimer() {
    if (hasListener) super.cancelGcTimer();
  }

  void emit(State state) {
    _state = state;
    _subject?.add(_state);
  }

  void setParams(Params params) {
    _options = _options.copyWith(params: () => params);
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
