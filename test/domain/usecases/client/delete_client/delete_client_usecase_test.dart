import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/core/utils/result.dart';
import 'package:lapor_kerja/domain/repositories/client_repository.dart';
import 'package:lapor_kerja/domain/usecases/client/delete_client/delete_client_params.dart';
import 'package:lapor_kerja/domain/usecases/client/delete_client/delete_client_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_client_usecase_test.mocks.dart';

@GenerateMocks([ClientRepository], customMocks: [MockSpec<ClientRepository>(as: #MockClientRepositoryForDelete)])
void main() {
  late DeleteClientUseCase useCase;
  late MockClientRepositoryForDelete mockRepository;

  setUp(() {
    mockRepository = MockClientRepositoryForDelete();
    useCase = DeleteClientUseCase(mockRepository);
  });

  setUpAll(() {
    provideDummy<Result<void>>(const Result.failed('dummy'));
  });

  group('DeleteClientUseCase', () {
    test('should call repository.softDeleteClient with correct id', () async {
      // Arrange
      const id = 1;
      final params = DeleteClientParams(id);
      when(mockRepository.softDeleteClient(id)).thenAnswer((_) async => const Result.success(null));

      // Act
      final result = await useCase.call(params);

      // Assert
      verify(mockRepository.softDeleteClient(id)).called(1);
      expect(result.isSuccess, true);
    });
  });
}