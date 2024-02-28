import 'package:fuery/src/base/query.dart';
import 'package:fuery/src/base/typedefs.dart';
import 'package:fuery/src/error/fuery_exception.dart';
import 'package:fuery/src/query_cache.dart';
import 'package:fuery/src/query_options.dart';

class Fuery {
  Fuery._();

  static final Fuery _singleton = Fuery._();
  static Fuery get instance => _singleton;

  QueryOptions _defaultQueryOptions = QueryOptions(
    gcTime: 1000 * 6 * 5,
    staleTime: 0,
  );
  QueryOptions get defaultOptions => _defaultQueryOptions;

  final QueryCache _queryCache = QueryCache();

  QueryCache get cache => _queryCache;

  void config(QueryOptions options) {
    _defaultQueryOptions = options;
  }

  void addQuery(QueryKey queryKey, QueryBase query) => _queryCache.add(queryKey, query);

  QueryBase? getQuery(QueryKey queryKey) => _queryCache.find(queryKey);

  T? getQueryData<T>(QueryKey queryKey) => _queryCache.find(queryKey)?.stream.value.data as T;

  bool hasQuery(QueryKey queryKey) => _queryCache.has(queryKey);

  void removeQuery(QueryKey queryKey) {
    _queryCache.remove(queryKey);
  }

  void setQueryData<T>(QueryKey queryKey, T data) {
    final QueryBase? query = _queryCache.find(queryKey);

    if (query == null) return;
    if (query.stream.value.data == null) return;
    if (query.stream.value.data is! T) {
      throw QueryStateTypeException(
        data: data,
        message: 'data is not type of $T: $data',
      );
    }

    query.emit(query.stream.value.copyWith(data: () => data));
  }

  void invalidateQueries({
    required QueryKey queryKey,
    bool? exact,
  }) {
    final List<QueryBase> filtered = _queryCache
        .findAll(
          key: queryKey,
          exact: exact,
        )
        .toList();

    for (final query in filtered) {
      query.invalidate();
    }
  }
}
