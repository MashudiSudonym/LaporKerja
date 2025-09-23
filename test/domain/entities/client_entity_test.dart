import 'package:flutter_test/flutter_test.dart';
import 'package:lapor_kerja/domain/entities/client_entity.dart';

void main() {
  group('ClientEntity', () {
    final testClient = ClientEntity(
      id: 1,
      name: 'Test Client',
      contactInfo: 'test@example.com',
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime(2023, 1, 1),
      isDeleted: false,
    );

    test('should create ClientEntity instance', () {
      expect(testClient.id, 1);
      expect(testClient.name, 'Test Client');
      expect(testClient.contactInfo, 'test@example.com');
      expect(testClient.isDeleted, false);
    });

    test('should serialize to JSON', () {
      final json = testClient.toJson();
      expect(json['id'], 1);
      expect(json['name'], 'Test Client');
      expect(json['contactInfo'], 'test@example.com');
      expect(json['isDeleted'], false);
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 1,
        'name': 'Test Client',
        'contactInfo': 'test@example.com',
        'createdAt': '2023-01-01T00:00:00.000',
        'updatedAt': '2023-01-01T00:00:00.000',
        'isDeleted': false,
      };
      final client = ClientEntity.fromJson(json);
      expect(client, testClient);
    });

    test('should support equality', () {
      final client2 = ClientEntity(
        id: 1,
        name: 'Test Client',
        contactInfo: 'test@example.com',
        createdAt: DateTime(2023, 1, 1),
        updatedAt: DateTime(2023, 1, 1),
        isDeleted: false,
      );
      expect(testClient, client2);
    });

    test('should support copyWith', () {
      final updatedClient = testClient.copyWith(name: 'Updated Client');
      expect(updatedClient.name, 'Updated Client');
      expect(updatedClient.id, testClient.id);
    });
  });
}