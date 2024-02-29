import 'package:fuery_core/src/base/cache.dart';
import 'package:fuery_core/src/base/query.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/util/cache_filter.dart';

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
      items: _queries,
      key: key,
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
