import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/mutation_options.dart';
import 'package:fuery_core/src/mutation_state.dart';

abstract class MutationBase<Args, Data, Err, State extends MutationState<Data, Err>> {
  MutationBase({
    required MutationKey mutationKey,
    MutationOptions<Args, Data, Err>? options,
  })  : _mutationKey = mutationKey,
        _options = options ?? MutationOptions(),
        _state = MutationState<Data, Err>() as State,
        _subject = BehaviorSubject() {
    _subject
      ..onCancel = () {
        print('MUTATION CANCEL');
        dispose();
      }
      ..onListen = () {
        print('MUTATION LISTEN');
      };
  }

  final MutationKey _mutationKey;
  MutationKey get mutationKey => _mutationKey;

  MutationOptions<Args, Data, Err> _options;
  MutationOptions<Args, Data, Err> get options => _options;

  State _state;
  State get state => _state;

  final BehaviorSubject<State> _subject;

  void mutate([Args? args]);

  Future<Data> mutateAsync([Args? args]);

  void emit(State state) {
    _state = state;
    _subject.add(state);
  }

  void setArgs(Args args) {
    _options = _options.copyWith(arguments: () => args);
  }

  Future<void> dispose() async {
    await _subject.close();
  }

  ValueStream<State> get stream {
    return _subject.stream;
  }

  bool get hasListener => _subject.hasListener;
}
