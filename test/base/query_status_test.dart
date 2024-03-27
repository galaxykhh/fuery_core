import 'package:fuery_core/src/base/query_state.dart';
import 'package:test/test.dart';

void main() {
  group('QueryStatus', () {
    test('QueryStatus.isIdle works properly.', () {
      const status = QueryStatus.idle;
      expect(status.isIdle, isTrue);
      expect(status.isPending, isFalse);
      expect(status.isFailure, isFalse);
      expect(status.isSuccess, isFalse);
    });

    test('QueryStatus.isPending works properly.', () {
      const status = QueryStatus.pending;
      expect(status.isIdle, isFalse);
      expect(status.isPending, isTrue);
      expect(status.isFailure, isFalse);
      expect(status.isSuccess, isFalse);
    });

    test('QueryStatus.isFailure works properly.', () {
      const status = QueryStatus.failure;
      expect(status.isIdle, isFalse);
      expect(status.isPending, isFalse);
      expect(status.isFailure, isTrue);
      expect(status.isSuccess, isFalse);
    });

    test('QueryStatus.isSuccess works properly', () {
      const status = QueryStatus.success;
      expect(status.isIdle, isFalse);
      expect(status.isPending, isFalse);
      expect(status.isFailure, isFalse);
      expect(status.isSuccess, isTrue);
    });
  });
}
