part of './base/mutation.dart';

class _MutationWithArgs<Args, Data, Err> extends Mutation<Args, Data, Err> {
  _MutationWithArgs({
    required MutationKey mutationKey,
    required MutationWithArgsFn<Args, Data, Err> mutationFn,
  })  : _mutationFn = mutationFn,
        super._(mutationKey: mutationKey);

  final MutationWithArgsFn<Args, Data, Err> _mutationFn;

  @override
  void mutate([Args? args]) {
    assert(args is Args, 'MutationWithArgs.mutate: arguments required');
    _mutationFn(args as Args);
  }

  @override
  Future<Data> mutateAsync([Args? args]) async {
    assert(args is Args, 'MutationWithArgs.mutateAsync: arguments required');
    return await _mutationFn(args as Args);
  }
}
