# Agent Guidelines for lapor_kerja

## Commands
- **Build**: `flutter build apk --flavor dev --target lib/main_dev.dart` (dev) or `flutter build apk --flavor prod --target lib/main_prod.dart` (prod)
- **Run**: `flutter run --flavor dev --target lib/main_dev.dart` (dev) or `flutter run --flavor prod --target lib/main_prod.dart` (prod)
- **Test all**: `flutter test`
- **Test single**: `flutter test test/widget_test.dart` or `flutter test --plain-name "Counter increments"`
- **Lint**: `flutter analyze`
- **Format**: `dart format .`
- **Code generation**: `flutter pub run build_runner build`
- **Database generation**: `flutter pub run build_runner build --delete-conflicting-outputs` (for Drift)

## Code Style
- **Imports**: Group by type (dart, flutter, third-party, local) with blank lines between groups
- **Naming**: camelCase for variables/functions, PascalCase for classes, snake_case for files
- **Types**: Explicit types for public APIs, `const` for compile-time constants
- **Widgets**: Use `const` constructors when possible, prefer `StatelessWidget` over `StatefulWidget`
- **State management**: Riverpod providers, avoid setState in complex widgets
- **Error handling**: `Result<T>` for repositories, try-catch for async ops, custom exceptions
- **Annotations**: `@freezed` for data classes, `@JsonSerializable` for JSON models, `@DriftTable` for DB entities
- **Formatting**: Follow dartfmt, 2-space indentation, 80-char line limit
- **Documentation**: `///` for public APIs, avoid inline comments unless complex logic

## Architecture
- **Tech Stack**: Flutter (Dart), Supabase (backend), Drift (local DB), Riverpod (state), Freezed (models), Result<T> (error handling)
- **Pattern**: Clean Architecture (Domain → Data → Presentation), offline-first design
- **Bootstrap**: All initialization in `lib/bootstrap.dart` (permissions, env loading, Supabase setup)
- **Development**: Build domain layer first, then data, then presentation. Test each layer before proceeding.