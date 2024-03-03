import 'package:fuery_core/src/base/query_state.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/util/timestamp.dart';

class QueryState<Data, Err> extends QueryStateBase<Data, Err> {
  QueryState({
    super.data,
    super.error,
    required super.status,
    required super.fetchStatus,
    required super.invalidated,
    required super.updatedAt,
  });

  QueryState<Data, Err> copyWith({
    ValueGetter<Data>? data,
    ValueGetter<Err>? error,
    QueryStatus? status,
    FetchStatus? fetchStatus,
    bool? invalidated,
  }) {
    return QueryState<Data, Err>(
      data: data != null ? data() : this.data,
      error: error != null ? error() : this.error,
      status: status ?? this.status,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      invalidated: invalidated ?? this.invalidated,
      updatedAt: data != null ? Timestamp.now() : updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QueryState<Data, Err> &&
        other.data == data &&
        other.error == error &&
        other.status == status &&
        other.fetchStatus == fetchStatus &&
        other.invalidated == invalidated &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => data.hashCode ^ error.hashCode ^ status.hashCode ^ fetchStatus.hashCode ^ invalidated.hashCode ^ updatedAt.hashCode;
}
