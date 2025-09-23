import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';

void main() {
  group('Result', () {
    test('Result.success creates Success instance', () {
      final result = Result<int>.success(42);
      expect(result, isA<Success<int>>());
      expect(result.isSuccess, true);
      expect(result.isFailed, false);
      expect(result.resultValue, 42);
      expect(result.errorMessage, null);
    });

    test('Result.failed creates Failed instance', () {
      final result = Result<int>.failed('Error message');
      expect(result, isA<Failed<int>>());
      expect(result.isSuccess, false);
      expect(result.isFailed, true);
      expect(result.resultValue, null);
      expect(result.errorMessage, 'Error message');
    });

    test('Success properties', () {
      const success = Success(42);
      expect(success.value, 42);
    });

    test('Failed properties', () {
      const failed = Failed('Error');
      expect(failed.message, 'Error');
    });
  });
}
