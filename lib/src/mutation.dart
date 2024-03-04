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

  static MutationBase _getCachedMutation<T>({
    required MutationKey? mutationKey,
    required MutationBase Function() orElse,
  }) {
    try {
      final bool hasMutationKey = mutationKey != null;

      if (hasMutationKey) {
        assert(mutationKey.isNotEmpty, 'mutationKey should not be empty');

        final MutationBase? mutation = Fuery.instance.getMutation(mutationKey);
        final bool exists = mutation is MutationBase;

        if (exists) {
          return mutation;
        }
      }

      return orElse();
    } catch(_) {
      rethrow;
    }
  }

  static MutationWithArgs<Args, Data, Err> args<Args, Data, Err>({
    required MutationWithArgsFn<Args, Data, Err> mutationFn,
    MutationKey? mutationKey,
    int? gcTime,
    MutationMutateCallback<Args>? onMutate,
    MutationSuccessCallback<Args, Data>? onSuccess,
    MutationErrorCallback<Args, Err>? onError,
  }) {
    return _getCachedMutation<MutationWithArgs<Args, Data, Err>>(
      mutationKey: mutationKey,
      orElse: () {
        final MutationWithArgs<Args, Data, Err> mutation = MutationWithArgs<Args, Data, Err>(
          mutationKey: mutationKey,
          mutationFn: mutationFn,
          options: MutationOptions<Args, Data, Err>(
            gcTime: gcTime,
            onMutate: onMutate,
            onSuccess: onSuccess,
            onError: onError,
          ),
        );

        if (mutationKey != null) Fuery.instance.addMutation(mutationKey, mutation);

        return mutation;
      },
    ) as MutationWithArgs<Args, Data, Err>;
  }

  static MutationWithoutArgs<Data, Err> noArgs<Data, Err>({
    required MutationWithoutArgsFn<Data, Err> mutationFn,
    MutationKey? mutationKey,
    int? gcTime,
    MutationMutateCallbackWithoutArgs? onMutate,
    MutationSuccessCallbackWithoutArgs<Data>? onSuccess,
    MutationErrorCallbackWithoutArgs<Err>? onError,
  }) {
    return _getCachedMutation<MutationWithoutArgs<Data, Err>>(
      mutationKey: mutationKey,
      orElse: () {
        final MutationWithoutArgs<Data, Err> mutation = MutationWithoutArgs<Data, Err>(
          mutationKey: mutationKey,
          mutationFn: mutationFn,
          options: MutationOptions(
            onMutate: (_) => onMutate?.call(),
            onSuccess: (_, data) => onSuccess?.call(data),
            onError: (_, error) => onError?.call(error),
          ),
        );

        if (mutationKey != null) Fuery.instance.addMutation(mutationKey, mutation);

        return mutation;
      },
    ) as MutationWithoutArgs<Data, Err>;
  }
}
