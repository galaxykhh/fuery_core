part of './base/mutation.dart';

sealed class Mutation<Args, Data, Err> extends MutationBase<Args, Data> {
  Mutation._({required super.mutationKey});

  static Mutation<Args, Data, Err> args<Args, Data, Err>({
    required MutationKey mutationKey,
    required MutationWithArgsFn<Args, Data, Err> mutationFn,
  }) {
    return _MutationWithArgs<Args, Data, Err>(
      mutationKey: mutationKey,
      mutationFn: mutationFn,
    );
  }

  static Mutation<void, Data, Err> noArgs<Data, Err>({
    required MutationKey mutationKey,
    required MutationWithoutArgsFn<Data, Err> mutationFn,
  }) {
    return _MutationWithoutArgs<Data, Err>(
      mutationKey: mutationKey,
      mutationFn: mutationFn,
    );
  }
}
