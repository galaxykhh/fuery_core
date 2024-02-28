import 'package:fuery/src/base/typedefs.dart';

class MutationOptions<Args, Data, Err> {
  final Args? arguments;
  final MutationMutateCallback<Args> onMutate;
  final MutationSuccessCallback<Args, Data> onSuccess;
  final MutationErrorCallback<Args, Err> onError;

  MutationOptions({
    this.arguments,
    this.onMutate,
    this.onSuccess,
    this.onError,
  });

  MutationOptions<Args, Data, Err> copyWith({
    Args? Function()? arguments,
  }) {
    return MutationOptions<Args, Data, Err>(
      arguments: arguments != null ? arguments() : this.arguments,
      onMutate: onMutate,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MutationOptions<Args, Data, Err> && other.arguments == arguments;
  }

  @override
  int get hashCode => arguments.hashCode;
}
