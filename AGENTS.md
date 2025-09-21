# Agent Guidelines for lapor_kerja

## Commands
- **Build**: `flutter build apk` (Android) or `flutter build ios` (iOS)
- **Run**: `flutter run`
- **Test all**: `flutter test`
- **Test single**: `flutter test test/widget_test.dart` or `flutter test --plain-name "Counter increments"`
- **Lint**: `flutter analyze`
- **Format**: `dart format .`
- **Code generation**: `flutter pub run build_runner build`
- **Database generation**: `flutter pub run build_runner build --delete-conflicting-outputs` (for Drift)

## Code Style
- **Imports**: Group by type (dart, flutter, third-party, local) with blank lines between groups
- **Naming**: camelCase for variables/functions, PascalCase for classes, snake_case for files
- **Types**: Use explicit types for public APIs, `const` for compile-time constants
- **Widgets**: Use `const` constructors when possible, prefer `StatelessWidget` over `StatefulWidget`
- **State management**: Use Riverpod providers, avoid setState in complex widgets
- **Error handling**: Use try-catch for async operations, throw custom exceptions
- **Annotations**: Use `@freezed` for data classes, `@JsonSerializable` for JSON models, `@DriftTable` for database entities
- **Formatting**: Follow dartfmt output, 2-space indentation, 80-char line limit
- **Documentation**: Use `///` for public APIs, avoid inline comments unless complex logic

## Tech Stack & Architecture
- **Frontend**: Flutter (Dart) for cross-platform UI
- **Backend**: Supabase (PostgreSQL, auth, realtime)
- **Local Database**: Drift (SQLite-based, type-safe)
- **State Management**: Riverpod with riverpod_generator
- **Data Models**: Freezed for immutable classes
- **Architecture**: Offline-first (local-first, background sync)