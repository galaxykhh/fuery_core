import 'package:spark_core/src/base/mutation_state.dart';

class MutationState<Data, Err> extends MutationStateBase<Data, Err> {
  MutationState({
    super.data,
    super.error,
    super.status = MutationStatus.idle,
  });

  MutationState<Data, Err> copyWith({
    Data? Function()? data,
    Err? Function()? error,
    MutationStatus? status,
  }) {
    return MutationState<Data, Err>(
      data: data != null ? data() : this.data,
      error: error != null ? error() : this.error,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MutationState<Data, Err> && other.data == data && other.error == error && other.status == status;
  }

  @override
  int get hashCode => data.hashCode ^ error.hashCode ^ status.hashCode;
}
