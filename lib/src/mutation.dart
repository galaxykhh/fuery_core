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
    return _MutationWithArgs<Args, Data, Err>(
      mutationKey: mutationKey,
      mutationFn: mutationFn,
      options: MutationOptions<Args, Data, Err>(
        onMutate: onMutate,
        onSuccess: onSuccess,
        onError: onError,
      ),
    );
  }

  static Mutation<void, Data, Err> noArgs<Data, Err>({
    required MutationKey mutationKey,
    required MutationWithoutArgsFn<Data, Err> mutationFn,
    MutationMutateCallbackWithoutArgs onMutate,
    MutationSuccessCallbackWithoutArgs<Data> onSuccess,
    MutationErrorCallbackWithoutArgs<Err> onError,
  }) {
    return _MutationWithoutArgs<Data, Err>(
      mutationKey: mutationKey,
      mutationFn: mutationFn,
      options: MutationOptions(
        onMutate: (_) => onMutate?.call(),
        onSuccess: (data, __) => onSuccess?.call(data),
        onError: (error, __) => onError?.call(error),
      ),
    );
  }
}
