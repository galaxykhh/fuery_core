import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/query_options.dart';
import 'package:fuery_core/src/query_state.dart';
import 'package:fuery_core/src/fuery_client.dart';

abstract class QueryBase<Data, Err, State extends QueryState<Data, Err>> {
  QueryBase({
    required QueryKey queryKey,
    required QueryOptions? options,
    required State state,
  })  : assert(queryKey.isNotEmpty, 'queryKey should not be empty'),
        _queryKey = queryKey,
        _options = options ?? Fuery.instance.defaultOptions,
        _state = state;

  final QueryKey _queryKey;
  QueryKey get queryKey => _queryKey;

  QueryOptions _options;
  QueryOptions get options => _options;

  State _state;

  BehaviorSubject<State>? _subject;

  Timer? _refetchTimer;
  Timer? _gcTimer;

  void _setRefetchTimer() {
    if (_options.refetchInterval > 0 && hasListener) {
      _refetchTimer ??= Timer.periodic(
        Duration(milliseconds: _options.refetchInterval),
        (_) => refetch(),
      );
    }
  }

  void _cancelRefetchTimer() {
    if (_refetchTimer != null) {
      _refetchTimer?.cancel();
      _refetchTimer = null;
    }
  }

  void _setGcTimer() {
    _gcTimer ??= Timer(
      Duration(milliseconds: _options.gcTime),
      () => Fuery.instance.removeQuery(_queryKey),
    );
  }

  void _cancelGcTimer() {
    if (_gcTimer != null && hasListener) {
      _gcTimer?.cancel();
      _gcTimer = null;
    }
  }

  Future<void> fetch();

  Future<void> refetch();

  void emit(State state) {
    _state = state;
    _subject?.add(state);
  }

  void invalidate() {
    emit(_state.copyWith(invalidated: true) as State);
  }

  void updateOptions(QueryOptions options) {
    if (_options == options) return;

    final bool shouldUpdateRefetchTimer = _options.refetchInterval != options.refetchInterval;
    _options = options;

    if (shouldUpdateRefetchTimer) {
      _cancelRefetchTimer();
      _setRefetchTimer();
    }
  }

  void wake() {
    if (_subject != null) return;

    _subject = BehaviorSubject<State>.seeded(_state)
      ..onListen = () {
        _setRefetchTimer();
        _cancelGcTimer();
      }
      ..onCancel = () {
        dispose();
      };
  }

  Future<void> dispose() async {
    await _subject?.close();
    _refetchTimer?.cancel();
    _subject = null;
    _setGcTimer();
  }

  ValueStream<State> get stream {
    wake();
    return _subject!.stream;
  }

  bool get hasListener => _subject?.hasListener ?? false;

  bool get isStale {
    if (_options.staleTime.isInfinite) return false;

    final QueryState state = stream.value;

    return state.invalidated ||
        state.updatedAt.value == 0 ||
        DateTime.now().difference(state.updatedAt.toDateTime()).inSeconds >= options.staleTime;
  }
}
