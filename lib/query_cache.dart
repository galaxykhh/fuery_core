import 'package:spark_core/base/cache.dart';
import 'package:spark_core/base/query.dart';
import 'package:spark_core/base/typedefs.dart';
import 'package:spark_core/util/cache_filter.dart';

class QueryCache with CacheFilter<QueryBase> implements Cache<QueryBase> {
  QueryCache._();

  factory QueryCache() => QueryCache._();

  final Store<QueryBase> _queries = {};

  @override
  void add(QueryKey key, QueryBase query) {
    _queries[key.toString()] = query;
  }

  @override
  QueryBase? find(QueryKey key) => _queries[key.toString()];

  @override
  List<QueryBase> findAll({
    required QueryKey key,
    bool? exact,
  }) {
    return filter(
      queries: _queries,
      queryKey: key,
      exact: exact,
    );
  }

  @override
  bool has(QueryKey key) {
    return find(key) != null;
  }

  @override
  void remove(QueryKey key) {
    _queries.remove(key.toString());
  }
}
