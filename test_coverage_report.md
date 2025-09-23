# Test Coverage Report

## Summary
- **Total Lines**: 127
- **Covered Lines**: 127
- **Coverage Percentage**: 100%
- **Total Tests**: 67

## Test Breakdown
- **Entity Tests**: 20 tests (5 entities × 4 tests each: creation, JSON serialization/deserialization, equality, copyWith)
- **Repository Tests**: 36 tests (5 repositories × 7-8 tests each: watching, CRUD operations, sync operations)
- **Core Utils Tests**: 11 tests (Result class, UseCase, Constants)

## Detailed Coverage by File

### Domain Layer
#### Entities
- `lib/domain/entities/client_entity.dart`: 100% (2/2 lines)
- `lib/domain/entities/client_entity.g.dart`: 100% (16/16 lines)
- `lib/domain/entities/income_entity.dart`: 100% (2/2 lines)
- `lib/domain/entities/income_entity.g.dart`: 100% (21/21 lines)
- `lib/domain/entities/project_entity.dart`: 100% (2/2 lines)
- `lib/domain/entities/project_entity.g.dart`: 100% (26/26 lines)
- `lib/domain/entities/task_entity.dart`: 100% (2/2 lines)
- `lib/domain/entities/task_entity.g.dart`: 100% (22/22 lines)
- `lib/domain/entities/time_entry_entity.dart`: 100% (2/2 lines)
- `lib/domain/entities/time_entry_entity.g.dart`: 100% (22/22 lines)

#### Repositories
- `lib/domain/repositories/client_repository.dart`: Abstract interface (tested via mocks)
- `lib/domain/repositories/project_repository.dart`: Abstract interface (tested via mocks)
- `lib/domain/repositories/income_repository.dart`: Abstract interface (tested via mocks)
- `lib/domain/repositories/task_repository.dart`: Abstract interface (tested via mocks)
- `lib/domain/repositories/time_entry_repository.dart`: Abstract interface (tested via mocks)

### Core Layer
- `lib/core/constants/constants.dart`: 100% (3/3 lines)
- `lib/core/utils/result.dart`: 100% (7/7 lines)
- `lib/core/utils/usecase.dart`: Abstract interface (tested via mocks)

## Test Coverage Details

### Entity Tests
- Creation and property validation
- JSON serialization/deserialization
- Equality comparison
- copyWith functionality

### Repository Tests
- Stream watching methods
- CRUD operations (Create, Read, Update, Soft Delete)
- Sync-related operations (get unsynced, mark as synced)
- Method signature validation via mocks

### Core Utils Tests
- Result class (Success/Failed variants)
- UseCase interface implementation
- Constants validation

## Notes
- All executable code lines are fully covered (100%)
- Abstract interfaces are tested through mock implementations
- Generated code from Freezed is included in coverage
- Repository interfaces now use Result<T> for error handling in Future methods
- Data layer (Drift models/DAOs) and presentation layer are not yet tested
- Bootstrap and main application files are not tested
- HTML coverage report available in `coverage/html/index.html`