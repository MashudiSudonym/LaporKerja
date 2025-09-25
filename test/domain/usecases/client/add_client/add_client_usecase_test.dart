import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'package:lapor_kerja/domain/usecases/client/add_client/add_client_params.dart';
import 'package:lapor_kerja/domain/usecases/client/add_client/add_client_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_client_usecase_test.mocks.dart';

@GenerateMocks([ClientRepository], customMocks: [MockSpec<ClientRepository>(as: #MockClientRepositoryForAdd)])
void main() {
  late AddClientUseCase useCase;
  late MockClientRepositoryForAdd mockRepository;

  setUp(() {
    mockRepository = MockClientRepositoryForAdd();
    useCase = AddClientUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('AddClientUseCase', () {
    test('should call repository.createClient with correct params', () async {
      // Arrange
      final params = AddClientParams('Test Client', 'test@example.com');
      when(mockRepository.createClient(any)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.createClient(any)).called(1);
      expect(result.isSuccess, true);
    });
  });
}

