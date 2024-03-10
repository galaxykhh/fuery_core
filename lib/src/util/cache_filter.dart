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

    return items.entries
        .where((item) {
          if (exact == true) {
            return _compare(
              key: key,
              targetKey: item.value.key,
              exact: exact,
            );
          }

          return _hasSameOrLongerKeyLength(
                key: key,
                targetKey: item.value.key,
              ) &&
              _compare(
                key: key,
                targetKey: item.value.key,
              );
        })
        .map((item) => item.value)
        .toList();
  }

  bool _hasSameKeyLength({
    required FueryKey key,
    required FueryKey targetKey,
  }) {
    return key.length == targetKey.length;
  }

  bool _hasLongerKeyLength({
    required FueryKey key,
    required FueryKey targetKey,
  }) {
    return key.length <= targetKey.length;
  }

  bool _hasSameOrLongerKeyLength({
    required FueryKey key,
    required FueryKey targetKey,
  }) {
    return _hasSameKeyLength(
          key: key,
          targetKey: targetKey,
        ) ||
        _hasLongerKeyLength(
          key: key,
          targetKey: targetKey,
        );
  }

  bool _shouldStringify(dynamic target) {
    return (target is! String && target is! int && target is! double && target is! bool);
  }

  bool _compare({
    required FueryKey key,
    required FueryKey targetKey,
    bool? exact,
  }) {
    if (exact == true && !_hasSameKeyLength(key: key, targetKey: targetKey)) {
      return false;
    }

    for (final (int, dynamic) item in key.indexed.toList()) {
      final dynamic keyItem = item.$2;
      final dynamic targetItem = targetKey[item.$1];
      final bool isSameType = targetItem.runtimeType == keyItem.runtimeType;
      final bool isSame = isSameType && _shouldStringify(targetItem) ? targetItem.toString() == keyItem.toString() : targetItem == keyItem;

      if (isSame) continue;

      return false;
    }

    return true;
  }
}
