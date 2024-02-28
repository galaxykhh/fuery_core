import 'package:rxdart/rxdart.dart';
import 'package:fuery/src/mutation_state.dart';

abstract class MutationResultBase<Data, Err, State extends MutationState<Data, Err>> {
  const MutationResultBase({
    required ValueStream<State> data,
    required Function mutate,
    required Function mutateAsync,
  })  : _data = data,
        _mutate = mutate,
        _mutateAsync = mutateAsync;

  final ValueStream<State> _data;
  ValueStream<State> get data => _data;

  final Function _mutate;
  Function get mutate => _mutate;

  final Function _mutateAsync;
  Function get mutateAsync => _mutateAsync;
}