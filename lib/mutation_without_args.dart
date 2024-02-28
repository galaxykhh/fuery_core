part of './base/mutation.dart';

class _MutationWithoutArgs<Data, Err> extends Mutation<void, Data, Err> {
  _MutationWithoutArgs._({
    required MutationKey mutationKey,
    required MutationWithoutArgsFn<Data, Err> mutationFn,
  })  : _mutationFn = mutationFn,
        super._(mutationKey: mutationKey);

  factory _MutationWithoutArgs({
    required MutationKey mutationKey,
    required MutationWithoutArgsFn<Data, Err> mutationFn,
  }) {
    return _MutationWithoutArgs._(mutationKey: mutationKey, mutationFn: mutationFn);
  }

  final MutationWithoutArgsFn<Data, Err> _mutationFn;

  @override
  void mutate([void args]) {
    _mutationFn();
  }

  @override
  Future<Data> mutateAsync([void args]) async {
    return await _mutationFn();
  }
}
