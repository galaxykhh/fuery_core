import 'package:fuery_core/src/base/mutation.dart';
import 'package:fuery_core/src/base/query.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:fuery_core/src/error/fuery_exception.dart';
import 'package:fuery_core/src/mutation_cache.dart';
import 'package:fuery_core/src/query_cache.dart';
import 'package:fuery_core/src/query_options.dart';

class Fuery {
  Fuery._();

  static final Fuery _singleton = Fuery._();
  static Fuery get instance => _singleton;

  QueryOptions _defaultQueryOptions = QueryOptions();
  QueryOptions get defaultOptions => _defaultQueryOptions;

  final QueryCache _queryCache = QueryCache();
  QueryCache get cache => _queryCache;

  final MutationCache _mutationCache = MutationCache();
  MutationCache get mutationCache => _mutationCache;

  void configQueryOptions(QueryOptions? queryOptions) {
    if (queryOptions != null) _defaultQueryOptions = queryOptions;
  }

  void addQuery(
    QueryKey queryKey,
    QueryBase query,
  ) {
    _queryCache.add(
      queryKey,
      query,
    );
  }

  QueryBase? getQuery(QueryKey queryKey) {
    return _queryCache.find(queryKey);
  }

  T? getQueryData<T>(QueryKey queryKey) {
    final QueryBase? query = getQuery(queryKey);

    return query?.stream.value as T?;
  }

  bool hasQuery(QueryKey queryKey) => _queryCache.has(queryKey);

  void removeQuery(QueryKey queryKey) {
    _queryCache.remove(queryKey);
  }

  void setQueryData<T>(
    QueryKey queryKey,
    T data,
  ) {
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

  void addMutation(
    MutationKey mutationKey,
    MutationBase mutation,
  ) {
    _mutationCache.add(
      mutationKey,
      mutation,
    );
  }

  MutationBase? getMutation(MutationKey mutationKey) {
    return _mutationCache.find(mutationKey);
  }

  T? getMutationData<T>(MutationKey mutationKey) {
    final MutationBase? mutation = getMutation(mutationKey);

    return mutation?.stream.value as T?;
  }

  bool hasMutation(MutationKey mutationKey) {
    return _mutationCache.has(mutationKey);
  }

  void removeMutation(MutationKey mutationKey) {
    _mutationCache.remove(mutationKey);
  }
}
