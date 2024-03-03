import 'package:fuery_core/src/base/typedefs.dart';

class MutationOptions<Args, Data, Err> {
  MutationOptions({
    Args? arguments,
    int? gcTime,
    MutationMutateCallback<Args>? onMutate,
    MutationSuccessCallback<Args, Data>? onSuccess,
    MutationErrorCallback<Args, Err>? onError,
  })  : _arguments = arguments,
        _gcTime = gcTime ?? 1000 * 60 * 5,
        _onMutate = onMutate,
        _onSuccess = onSuccess,
        _onError = onError;

  final Args? _arguments;
  Args? get arguments => _arguments;

  final int _gcTime;
  int get gctime => _gcTime;

  final MutationMutateCallback<Args>? _onMutate;
  MutationMutateCallback<Args>? get onMutate => _onMutate;

  final MutationSuccessCallback<Args, Data>? _onSuccess;
  MutationSuccessCallback<Args, Data>? get onSuccess => _onSuccess;

  final MutationErrorCallback<Args, Err>? _onError;
  MutationErrorCallback<Args, Err>? get onError => _onError;

  MutationOptions<Args, Data, Err> copyWith({
    ValueGetter<Args>? arguments,
    ValueGetter<int>? gcTime,
    ValueGetter<MutationMutateCallback<Args>>? onMutate,
    ValueGetter<MutationSuccessCallback<Args, Data>>? onSuccess,
    ValueGetter<MutationErrorCallback<Args, Err>>? onError,
  }) {
    return MutationOptions<Args, Data, Err>(
      arguments: arguments != null ? arguments() : this.arguments,
      onMutate: onMutate != null ? onMutate() : this.onMutate,
      onSuccess: onSuccess != null ? onSuccess() : this.onSuccess,
      onError: onError != null ? onError() : this.onError,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MutationOptions<Args, Data, Err> &&
        other._arguments == _arguments &&
        other._gcTime == _gcTime &&
        other._onMutate == _onMutate &&
        other._onSuccess == _onSuccess &&
        other._onError == _onError;
  }

  @override
  int get hashCode {
    return _arguments.hashCode ^ _gcTime.hashCode ^ _onMutate.hashCode ^ _onSuccess.hashCode ^ _onError.hashCode;
  }
}
