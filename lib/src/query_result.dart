import 'package:fuery_core/src/base/query_result.dart';
import 'package:fuery_core/src/query_state.dart';

class QueryResult<Data, Err> extends QueryResultBase<Data, Err, QueryState<Data, Err>> {
  QueryResult({
    required super.data,
    required super.refetch,
    required super.updateOptions,
  });
}
