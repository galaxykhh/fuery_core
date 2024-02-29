import 'package:fuery_core/src/base/typedefs.dart';

mixin CacheFilter<T> {
  List<T> filter({
    required Store<T> items,
    QueryKey? key,
    bool? exact = false,
  }) =>
      items.entries.map((e) => e.value).toList();
}
