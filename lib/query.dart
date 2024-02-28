import 'package:rxdart/rxdart.dart';
import 'package:spark_core/base/query.dart';
import 'package:spark_core/base/query_state.dart';
import 'package:spark_core/base/typedefs.dart';
import 'package:spark_core/query_options.dart';
import 'package:spark_core/query_result.dart';
import 'package:spark_core/query_state.dart';
import 'package:spark_core/spark_client.dart';
import 'package:spark_core/util/timestamp.dart';

class Query<Data, Err> extends QueryBase<Data, Err, QueryState<Data, Err>> {
  Query._({
    required QueryKey queryKey,
    required QueryFn<Data> queryFn,
    QueryOptions? options,
  })  : _queryFn = queryFn,
        super(
          queryKey: queryKey,
          state: QueryState<Data, Err>(
            data: options?.initialData,
            status: QueryStatus.idle,
            fetchStatus: FetchStatus.idle,
            invalidated: false,
            updatedAt: options?.initialData == null ? const Timestamp(0) : Timestamp.now(),
          ),
          options: QueryOptions<Data>(
            initialData: options?.initialData,
            gcTime: options?.gcTime ?? SparkClient.instance.defaultOptions.gcTime,
            staleTime: options?.staleTime ?? SparkClient.instance.defaultOptions.staleTime,
            refetchInterval: options?.refetchInterval ?? SparkClient.instance.defaultOptions.refetchInterval,
          ),
        );

  static QueryResult<Data, Err> use<Data, Err>({
    required QueryKey queryKey,
    required QueryFn<Data> queryFn,
    int? gcTime,
    int? staleTime,
    int? refetchInterval,
    Data? initialData,
  }) {
    assert(queryKey.isNotEmpty, 'queryKey should not be empty');

    QueryBase? query = SparkClient.instance.getQuery(queryKey);
    final QueryOptions<Data> options = QueryOptions(
      gcTime: gcTime,
      initialData: initialData,
      staleTime: staleTime,
      refetchInterval: refetchInterval,
    );
    final bool exists = query != null;

    if (exists) {
      final bool shouldRefetch = !query.stream.value.isLoading && query.isStale;
      if (shouldRefetch) {
        query
          ..updateOptions(options)
          ..refetch();
      }
    } else {
      query = Query<Data, Err>._(
        queryKey: queryKey,
        queryFn: queryFn,
        options: options,
      );
      SparkClient.instance.addQuery(queryKey, query..fetch());
    }

    return QueryResult<Data, Err>(
      data: query.stream as ValueStream<QueryState<Data, Err>>,
      refetch: query.refetch,
      updateOptions: query.updateOptions,
    );
  }

  final QueryFn<Data> _queryFn;

  @override
  Future<void> fetch() async {
    if (stream.value.isLoading) return;

    emit(stream.value.copyWith(
      status: QueryStatus.pending,
      fetchStatus: FetchStatus.fetching,
    ));

    await _invokeQueryFn();
  }

  @override
  Future<void> refetch() async {
    final bool shouldSkip = stream.value.isLoading || stream.value.isRefetching;

    if (shouldSkip) return;

    emit(stream.value.copyWith(
      status: stream.value.status.isFailure ? QueryStatus.pending : stream.value.status,
      fetchStatus: FetchStatus.refetching,
      error: () => stream.value.status.isFailure ? null : stream.value.error,
    ));

    await _invokeQueryFn();
  }

  @override
  void invalidate() {
    super.invalidate();

    if (hasListener) refetch();
  }

  Future<void> _invokeQueryFn() async {
    try {
      final Data data = await _queryFn();
      emit(stream.value.copyWith(
        data: () => data,
        status: QueryStatus.success,
        fetchStatus: FetchStatus.idle,
      ));
    } catch (e) {
      emit(stream.value.copyWith(
        error: () => e as Err,
        status: QueryStatus.failure,
        fetchStatus: FetchStatus.idle,
      ));
    }
  }
}
