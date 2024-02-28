import 'dart:async';

import 'package:fuery/src/base/mutation.dart';
import 'package:fuery/src/base/mutation_state.dart';
import 'package:fuery/src/base/typedefs.dart';
import 'package:fuery/src/mutation_options.dart';
import 'package:fuery/src/mutation_state.dart';

part 'mutation_with_args.dart';
part 'mutation_without_args.dart';

sealed class Mutation<Args, Data, Err> extends MutationBase<Args, Data, Err, MutationState<Data, Err>> {
  Mutation._({
    MutationKey? mutationKey,
    super.options,
  }) : super(mutationKey: mutationKey ?? []);

  static Mutation<Args, Data, Err> args<Args, Data, Err>({
    required MutationWithArgsFn<Args, Data, Err> mutationFn,
    MutationKey? mutationKey,
    MutationMutateCallback<Args> onMutate,
    MutationSuccessCallback<Args, Data> onSuccess,
    MutationErrorCallback<Args, Err> onError,
  }) {
    final Mutation<Args, Data, Err> mutation = _MutationWithArgs<Args, Data, Err>(
      mutationKey: mutationKey,
      mutationFn: mutationFn,
      options: MutationOptions<Args, Data, Err>(
        onMutate: onMutate,
        onSuccess: onSuccess,
        onError: onError,
      ),
    ).._setSubscription();

    return mutation;
  }

  static Mutation<void, Data, Err> noArgs<Data, Err>({
    MutationKey? mutationKey,
    required MutationWithoutArgsFn<Data, Err> mutationFn,
    MutationMutateCallbackWithoutArgs onMutate,
    MutationSuccessCallbackWithoutArgs<Data> onSuccess,
    MutationErrorCallbackWithoutArgs<Err> onError,
  }) {
    final Mutation<void, Data, Err> mutation = _MutationWithoutArgs<Data, Err>(
      mutationKey: mutationKey,
      mutationFn: mutationFn,
      options: MutationOptions(
        onMutate: (_) => onMutate?.call(),
        onSuccess: (data, __) => onSuccess?.call(data),
        onError: (error, __) => onError?.call(error),
      ),
    ).._setSubscription();

    return mutation;
  }

  void _setSubscription() {
    _subscription = stream.listen((state) {
      switch (state.status) {
        case MutationStatus.pending:
          print('MUTATE:::');
          options.onMutate?.call(options.arguments as Args);
          break;

        case MutationStatus.failure:
          print('FAILURE:::');
          assert(state.error is Err, 'Err should not be null');
          options.onError?.call(
            state.error as Err,
            options.arguments as Args,
          );
          break;

        case MutationStatus.success:
          print('SUCCESS:::');
          options.onSuccess?.call(
            state.data as Data,
            options.arguments as Args,
          );
          break;

        default:
      }
    });
  }

  late final StreamSubscription _subscription;

  @override
  Future<void> dispose() async {
    _subscription.cancel();
    super.dispose();
  }
}
