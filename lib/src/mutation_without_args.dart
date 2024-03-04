part of 'mutation.dart';

class MutationWithoutArgs<Data, Err> extends Mutation<void, Data, Err> {
  MutationWithoutArgs({
    required MutationWithoutArgsFn<Data, Err> mutationFn,
    MutationOptions<void, Data, Err>? options,
    MutationKey? mutationKey,
  })  : _mutationFn = mutationFn,
        super._(
          mutationKey: mutationKey,
          options: options,
        );

  final MutationWithoutArgsFn<Data, Err> _mutationFn;

  Future<Data> _invoke() async {
    emit(stream.value.copyWith(status: MutationStatus.pending));

    try {
      final Future<Data> future = _mutationFn();

      options.onMutate?.call(null);

      final Data data = await future;

      options.onSuccess?.call(null, data);

      return data;
    } catch (e) {
      options.onError?.call(null, e as Err);
      rethrow;
    }
  }

  void mutate() => _invoke();

  Future<Data> mutateAsync() async => await _invoke();
}
