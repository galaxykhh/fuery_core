import 'package:fuery_core/src/query_options.dart';
import 'package:fuery_core/src/query_state.dart';
import 'package:rxdart/rxdart.dart';

abstract class QueryResultBase<Data, Err, State extends QueryState<Data, Err>> {
  const QueryResultBase({
    required ValueStream<State> data,
    required void Function() refetch,
    required void Function(QueryOptions<Data> options) updateOptions,
  })  : _data = data,
        _refetch = refetch,
        _updateOptions = updateOptions;

  final ValueStream<State> _data;
  ValueStream<State> get data => _data;

  final void Function() _refetch;
  void Function() get refetch => _refetch;

  final void Function(QueryOptions<Data> options) _updateOptions;

  void updateOptions({
    int? gcTime,
    int? staleTime,
    int? refetchInterval,
    Data? initialData,
  }) {
    _updateOptions(QueryOptions<Data>(
      gcTime: gcTime,
      staleTime: staleTime,
      refetchInterval: refetchInterval,
      initialData: initialData,
    ));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is QueryResultBase &&
      other._data == _data &&
      other._refetch == _refetch &&
      other._updateOptions == _updateOptions;
  }

  @override
  int get hashCode => _data.hashCode ^ _refetch.hashCode ^ _updateOptions.hashCode;
}
