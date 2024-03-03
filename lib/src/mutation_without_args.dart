part of 'mutation.dart';

class _MutationWithoutArgs<Data, Err> extends Mutation<void, Data, Err> {
  _MutationWithoutArgs({
    required MutationWithoutArgsFn<Data, Err> mutationFn,
    MutationOptions<void, Data, Err>? options,
    MutationKey? mutationKey,
  })  : _mutationFn = mutationFn,
        super._(
          mutationKey: mutationKey,
          options: options,
        );

  final MutationWithoutArgsFn<Data, Err> _mutationFn;

  @override
  void mutate([void args = Null]) {
    emit(stream.value.copyWith(status: MutationStatus.pending));

    _mutationFn().then(
      (result) {
        emit(stream.value.copyWith(
          data: () => result,
          status: MutationStatus.success,
        ));
        options.onSuccess?.call(result, null);
      },
      onError: (error) {
        emit(stream.value.copyWith(
          error: error,
          status: MutationStatus.failure,
        ));
        options.onError?.call(error, null);
      },
    );

    options.onMutate?.call(null);
  }

  @override
  Future<Data> mutateAsync([void args = Null]) async {
    emit(stream.value.copyWith(status: MutationStatus.pending));

    try {
      final Future<Data> future = _mutationFn();

      options.onMutate?.call(null);

      final Data data = await future;

      options.onSuccess?.call(data, null);

      return data;
    } catch (e) {
      options.onError?.call(e as dynamic, null);
      rethrow;
    }
  }
}
