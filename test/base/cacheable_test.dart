import 'package:fuery_core/src/base/cacheable.dart';
import 'package:fuery_core/src/base/typedefs.dart';
import 'package:test/test.dart';

void main() {
  group('Cacheable', () {
    final FueryKey key = ['A', 1];
    final Cacheable cacheable = Cacheable(key: key);

    test('Cacheable.key returns the key as it is', () {
      expect(cacheable.key == key, isTrue);
    });

    test('Cacheable.encodedKey returns the stringified key', () {
      expect(cacheable.encodedKey, isA<String>());
      expect(cacheable.encodedKey == key.toString(), isTrue);
    });
  });
}
