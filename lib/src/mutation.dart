import 'dart:async';

import 'package:fuery_core/src/base/mutation.dart';
import 'package:fuery_core/src/base/mutation_state.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/fuery_client.dart';
import 'package:fuery_core/src/mutation_options.dart';
import 'package:fuery_core/src/mutation_state.dart';

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
    int? gcTime,
    MutationMutateCallback<Args> onMutate,
    MutationSuccessCallback<Args, Data> onSuccess,
    MutationErrorCallback<Args, Err> onError,
  }) {
    if (mutationKey != null) {
      assert(mutationKey.isNotEmpty, 'mutationKey should not be empty');
    }

    final Mutation<Args, Data, Err> mutation = _MutationWithArgs<Args, Data, Err>(
      mutationKey: mutationKey,
      mutationFn: mutationFn,
      options: MutationOptions<Args, Data, Err>(
        gcTime: gcTime,
        onMutate: onMutate,
        onSuccess: onSuccess,
        onError: onError,
      ),
    );

    if (mutationKey != null) {
      Fuery.instance.addMutation(mutationKey, mutation);
    }

    return mutation.._setSubscription();
  }

  static Mutation<void, Data, Err> noArgs<Data, Err>({
    required MutationWithoutArgsFn<Data, Err> mutationFn,
    MutationKey? mutationKey,
    int? gcTime,
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
    );

    return mutation.._setSubscription();
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
