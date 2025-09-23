# Test Coverage Report

## Summary
- **Total Lines**: 127
- **Covered Lines**: 127
- **Coverage Percentage**: 100%

## Detailed Coverage by File

### Domain Layer
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

### Core Layer
- `lib/core/constants/constants.dart`: 100% (3/3 lines)
- `lib/core/utils/result.dart`: 100% (7/7 lines)

## Notes
- Tests cover entity serialization, deserialization, equality, and copyWith functionality.
- Core utilities like Result class and Constants are fully tested.
- Data models (Drift tables) and presentation layer are not yet tested.
- Generated code from Freezed is included in coverage.