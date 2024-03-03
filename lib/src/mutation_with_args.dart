part of 'mutation.dart';

class _MutationWithArgs<Args, Data, Err> extends Mutation<Args, Data, Err> {
  _MutationWithArgs({
    required MutationWithArgsFn<Args, Data, Err> mutationFn,
    MutationOptions<Args, Data, Err>? options,
    MutationKey? mutationKey,
  })  : _mutationFn = mutationFn,
        super._(
          mutationKey: mutationKey,
          options: options,
        );

  final MutationWithArgsFn<Args, Data, Err> _mutationFn;

  @override
  void mutate([Args? args]) async {
    assert(args is Args, 'arguments should not be null');

    setArgs(args as Args);
    emit(stream.value.copyWith(status: MutationStatus.pending));

    options.onMutate?.call(args);

    _mutationFn(args).then(
      (result) {
        emit(stream.value.copyWith(
          data: () => result,
          status: MutationStatus.success,
        ));
        options.onSuccess?.call(result, args);
      },
      onError: (error) {
        emit(stream.value.copyWith(
          error: error,
          status: MutationStatus.failure,
        ));
        options.onError?.call(error, args);
        throw error;
      },
    );
  }

  @override
  Future<Data> mutateAsync([Args? args]) async {
    assert(args is Args, 'MutationWithArgs: args required');

    setArgs(args as Args);
    emit(stream.value.copyWith(status: MutationStatus.pending));

    try {
      final Future<Data> future = _mutationFn(args);

      options.onMutate?.call(args);

      final Data data = await future;

      options.onSuccess?.call(data, args);

      return data;
    } catch (e) {
      emit(stream.value.copyWith(status: MutationStatus.failure, error: e as dynamic));
      options.onError?.call(e as dynamic, args);
      rethrow;
    }
  }
}
