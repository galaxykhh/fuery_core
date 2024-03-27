import 'package:fuery_core/src/base/query_state.dart';
import 'package:test/test.dart';

void main() {
  group('FetchStatus', () {
    test('FetchStatus.isIdle works properly.', () {
      const status = FetchStatus.idle;
      expect(status.isIdle, isTrue);
      expect(status.isFetching, isFalse);
      expect(status.isRefetching, isFalse);
    });

    test('FetchStatus.isFetching works properly.', () {
      const status = FetchStatus.fetching;
      expect(status.isIdle, isFalse);
      expect(status.isFetching, isTrue);
      expect(status.isRefetching, isFalse);
    });

    test('FetchStatus.isRefetching works properly.', () {
      const status = FetchStatus.refetching;
      expect(status.isIdle, isFalse);
      expect(status.isFetching, isFalse);
      expect(status.isRefetching, isTrue);
    });
  });
}
