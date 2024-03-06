import 'package:fuery_core/src/base/cacheable.dart';
import 'package:fuery_core/src/base/typedefs.dart';

mixin CacheFilter<T extends Cacheable> {
  List<T> filter({
    required Store<T> items,
    FueryKey? key,
    bool? exact,
  }) {
    if (key == null) {
      return items.entries.map((item) => item.value).toList();
    }

    assert(key.isNotEmpty, 'key should not be empty');

    return items.entries.where((item) {
      if (exact == true) return item.value.key == key;

      return (
        _hasSameOrLongerKeyLength(key: key, target: item.value)
      );
    }).map((item) => item.value).toList();
  }

  bool _hasSameOrLongerKeyLength({
    required FueryKey key,
    required T target,
  }) {
    return key.length >= target.key.length;
  }
}
