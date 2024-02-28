import 'package:spark_core/base/typedefs.dart';

mixin CacheFilter<T> {
  List<T> filter({
    required Store<T> queries,
    QueryKey? queryKey,
    bool? exact = false,
  }) =>
      queries.entries.map((e) => e.value).toList();
}
