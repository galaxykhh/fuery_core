import 'package:fuery_core/src/base/mutation_state.dart';
import 'package:test/test.dart';

void main() {
  group('MutationStatus', () {
    test('MutationStatus.isIdle works properly.', () {
      const status = MutationStatus.idle;
      expect(status.isIdle, isTrue);
      expect(status.isPending, isFalse);
      expect(status.isFailure, isFalse);
      expect(status.isSuccess, isFalse);
    });

    test('MutationStatus.isPending works properly.', () {
      const status = MutationStatus.pending;
      expect(status.isIdle, isFalse);
      expect(status.isPending, isTrue);
      expect(status.isFailure, isFalse);
      expect(status.isSuccess, isFalse);
    });

    test('MutationStatus.isFailure works properly.', () {
      const status = MutationStatus.failure;
      expect(status.isIdle, isFalse);
      expect(status.isPending, isFalse);
      expect(status.isFailure, isTrue);
      expect(status.isSuccess, isFalse);
    });

    test('MutationStatus.isSuccess works properly', () {
      const status = MutationStatus.success;
      expect(status.isIdle, isFalse);
      expect(status.isPending, isFalse);
      expect(status.isFailure, isFalse);
      expect(status.isSuccess, isTrue);
    });
  });
}
