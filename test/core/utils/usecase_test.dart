import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/usecase.dart';

// Mock implementation for testing
class MockUseCase implements UseCase<int, String> {
  @override
  Future<int> call(String params) async {
    return params.length;
  }
}

void main() {
  group('UseCase', () {
    test('MockUseCase implements UseCase correctly', () async {
      final useCase = MockUseCase();
      final result = await useCase('test');
      expect(result, 4);
    });
  });
}