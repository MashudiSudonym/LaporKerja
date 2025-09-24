import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';
import 'package:lapor_kerja/data/datasources/local/app_database.dart';
import 'package:lapor_kerja/data/mappers/client_mapper.dart';

void main() {
  group('ClientMapper', () {
    final now = DateTime.now();

    test('toEntity converts Client to ClientEntity', () {
      final client = Client(
        id: 1,
        remoteId: 'remote-1',
        isSynced: true,
        lastModified: now,
        isDeleted: false,
        name: 'Test Client',
        contactInfo: 'test@example.com',
        createdAt: now,
        updatedAt: now,
      );

      final entity = client.toEntity();

      expect(entity.id, 1);
      expect(entity.name, 'Test Client');
      expect(entity.contactInfo, 'test@example.com');
      expect(entity.createdAt, now);
      expect(entity.updatedAt, now);
      expect(entity.isDeleted, false);
    });

    test(
      'toCompanion converts ClientEntity to ClientsCompanion with id > 0',
      () {
        final entity = ClientEntity(
          id: 1,
          name: 'Test Client',
          contactInfo: 'test@example.com',
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
        );

        final companion = entity.toCompanion();

        expect(companion.id.value, 1);
        expect(companion.name.value, 'Test Client');
        expect(companion.contactInfo.value, 'test@example.com');
        expect(companion.createdAt.value, now);
        expect(companion.updatedAt.value, now);
        expect(companion.isDeleted.value, false);
      },
    );

    test(
      'toCompanion converts ClientEntity to ClientsCompanion with id == 0',
      () {
        final entity = ClientEntity(
          id: 0,
          name: 'New Client',
          contactInfo: null,
          createdAt: now,
          updatedAt: now,
          isDeleted: false,
        );

        final companion = entity.toCompanion();

        expect(companion.name.value, 'New Client');

        expect(companion.createdAt.value, now);
        expect(companion.updatedAt.value, now);
        expect(companion.isDeleted.value, false);
      },
    );
  });
}
