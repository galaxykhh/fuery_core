part of 'mutation.dart';

class MutationWithArgs<Args, Data, Err> extends Mutation<Args, Data, Err> {
  MutationWithArgs({
    required MutationWithArgsFn<Args, Data, Err> mutationFn,
    MutationOptions<Args, Data, Err>? options,
    MutationKey? mutationKey,
  })  : _mutationFn = mutationFn,
        super._(
          mutationKey: mutationKey,
          options: options,
        );

  final MutationWithArgsFn<Args, Data, Err> _mutationFn;

  Future<Data> _invoke(Args args) async {
    setArguments(args);
    emit(stream.value.copyWith(status: MutationStatus.pending));

    try {
      final Future<Data> future = _mutationFn(args);

      options.onMutate?.call(args);

      final Data data = await future;

      options.onSuccess?.call(args, data);

      return data;
    } catch (e) {
      emit(
        stream.value.copyWith(
          status: MutationStatus.failure,
          error: () => e as Err,
        ),
      );
      options.onError?.call(args, e as Err);
      rethrow;
    }
  }

  void mutate(Args args) => _invoke(args);

  Future<Data> mutateAsync(Args args) async => await _invoke(args);
}
