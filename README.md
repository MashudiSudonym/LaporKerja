# LaporKerja

Aplikasi Android yang dirancang khusus untuk membantu freelancer yang bekerja mandiri dalam mengelola pekerjaan mereka secara efisien.

## Deskripsi

LaporKerja adalah aplikasi offline-first untuk freelancer yang memungkinkan pengelolaan proyek, pelacakan waktu, dan manajemen pendapatan. Aplikasi ini tetap berfungsi penuh tanpa koneksi internet, dengan sinkronisasi otomatis ke cloud saat tersedia.

## Fitur Utama

### Manajemen Proyek dan Tugas ✅ (Implemented)
- Membuat proyek baru dengan asosiasi klien
- Menambahkan tugas di bawah setiap proyek
- Status tugas: To-Do, In Progress, Completed, Revision
- Penetapan deadline untuk proyek dan tugas

### Pelacakan Waktu ✅ (CRUD Implemented, Timer Pending)
- Entri waktu manual ✅
- Timer aktif dengan fitur start/stop 🔄 (In Development)
- Laporan waktu per tugas, proyek, atau rentang waktu 🔄 (Basic reports available)

### Manajemen Pendapatan ✅ (Implemented)
- Pencatatan pendapatan per proyek
- Status pembayaran: Belum Ditagih, Belum Lunas, Lunas, Lewat Jatuh Tempo
- Pencatatan uang muka atau pembayaran termin

### Fitur Tambahan
- Dashboard utama dengan ringkasan informasi 🔄 (In Development)
- Manajemen klien ✅ (Implemented)
- Laporan & analitik dengan grafik 🔄 (Basic reports, charts pending)
- Pembuatan tagihan dalam format PDF 🔄 (Planned)
- Notifikasi & pengingat untuk deadline 🔄 (In Development)
- **Auto-sync**: Sinkronisasi otomatis saat aplikasi start (background, tidak memblokir UI) 🔄 (Basic sync, full background pending)

## Tech Stack

- **Frontend**: Flutter (Dart) untuk cross-platform UI
- **Backend**: Supabase (PostgreSQL, autentikasi, realtime)
- **Database Lokal**: Drift (SQLite-based, type-safe)
- **State Management**: Riverpod dengan riverpod_generator
- **Data Models**: Freezed untuk immutable classes
- **Error Handling**: Result<T> untuk type-safe error handling di domain layer
- **Architecture**: Offline-first (local-first, background sync)

## Persyaratan Sistem

- Flutter SDK (versi fixed via Mise)
- Dart SDK
- Mise (untuk version management Flutter)
- Android Studio atau VS Code dengan ekstensi Flutter
- Perangkat Android untuk testing

## Bootstrap Initialization

File `lib/bootstrap.dart` bertanggung jawab untuk semua inisialisasi aplikasi sebelum `runApp()`. Tugas-tugas yang dilakukan:

### 1. **WidgetsFlutterBinding.ensureInitialized()**
   - Menginisialisasi binding Flutter untuk akses platform sebelum runApp

### 2. **Request Permissions**
   - `Permission.notification.request()` - untuk background sync notifications
   - `Permission.ignoreBatteryOptimizations.request()` - untuk background tasks

### 3. **Load Environment Variables**
   - Load `.env` berdasarkan flavor:
     - DEV: `assets/dev/.env`
     - PROD: `assets/prod/.env`
   - Menggunakan `dotenv.load(fileName: ...)`

### 4. **Initialize Supabase**
   - `Supabase.initialize()` dengan:
     - `url`: `dotenv.env['SUPABASE_URL']!`
     - `anonKey`: `dotenv.env['SUPABASE_ANON_KEY']!`

### 5. **Run App**
   - `runApp(ProviderScope(observers: [MyObserver()], child: await builder()))`

### Aturan Penting:
- **Semua inisialisasi yang memerlukan akses platform atau konfigurasi awal HARUS dilakukan di bootstrap.dart**
- **Jangan lakukan inisialisasi di service classes atau providers** - gunakan `Supabase.instance.client` langsung setelah inisialisasi
- **Bootstrap menangani cross-flavor configuration** untuk dev/prod environments

## Setup dan Instalasi

1. **Clone repository**:
   ```bash
   git clone <repository-url>
   cd lapor_kerja
   ```

2. **Install Mise** (jika belum terinstall):
   ```bash
   curl https://mise.jdx.dev/install.sh | sh
   ```

3. **Setup Flutter version**:
   ```bash
   mise install
   ```

4. **Install dependencies**:
   ```bash
   flutter pub get
   ```

5. **Setup environment files**:
   - Buat folder `assets/dev` dan `assets/prod` jika belum ada:
     ```bash
     mkdir -p assets/dev assets/prod
     ```
   - Salin file `.env` ke `assets/dev/.env` untuk development
   - Salin file `.env` ke `assets/prod/.env` untuk production
   - Pastikan file `.env` berisi konfigurasi yang diperlukan (misalnya Supabase keys)

6. **Generate code**:
   ```bash
   flutter pub run build_runner build
   ```

7. **Run aplikasi**:
   - Development: `flutter run --flavor dev --target lib/main_dev.dart`
   - Production: `flutter run --flavor prod --target lib/main_prod.dart`

## Commands

- **Build**: `flutter build apk` (Android) atau `flutter build ios` (iOS)
- **Run**: `flutter run`
- **Test all**: `flutter test`
- **Test single**: `flutter test test/widget_test.dart` atau `flutter test --plain-name "Counter increments"`
- **Lint**: `flutter analyze`
- **Format**: `dart format .`
- **Code generation**: `flutter pub run build_runner build`
- **Database generation**: `flutter pub run build_runner build --delete-conflicting-outputs` (untuk Drift)
- **Sync data**: Manual sync via UI (background auto-sync in development)
- **Generate reports**: Basic reports available in time entries page (advanced analytics pending)

## Struktur Project

```
lapor_kerja/
├── android/
│   ├── app/
│   │   ├── src/
│   │   │   ├── debug/
│   │   │   ├── main/
│   │   │   │   ├── kotlin/
│   │   │   │   │   └── com/tigasatudesember/lapor_kerja/
│   │   │   │   ├── res/
│   │   │   │   │   ├── drawable/
│   │   │   │   │   ├── drawable-v21/
│   │   │   │   │   ├── mipmap-hdpi/
│   │   │   │   │   ├── mipmap-mdpi/
│   │   │   │   │   ├── mipmap-xhdpi/
│   │   │   │   │   ├── mipmap-xxhdpi/
│   │   │   │   │   ├── mipmap-xxxhdpi/
│   │   │   │   │   ├── values/
│   │   │   │   │   └── values-night/
│   │   │   │   └── AndroidManifest.xml
│   │   │   ├── profile/
│   │   │   └── AndroidManifest.xml
│   │   ├── build.gradle.kts
│   │   └── .gitignore
│   ├── gradle/
│   │   └── wrapper/
│   │       └── gradle-wrapper.properties
│   ├── .gitignore
│   ├── build.gradle.kts
│   ├── gradle.properties
│   └── settings.gradle.kts
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   └── utils/
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── main_page/
│   │   └── providers/
│   │       └── router/
│   ├── app.dart
│   ├── bootstrap.dart
│   ├── main_dev.dart
│   └── main_prod.dart
├── assets/
│   ├── dev/
│   └── prod/
├── test/
├── .vscode/
├── .idea/
│   ├── runConfigurations/
│   ├── caches/
│   └── libraries/
├── build/
├── .git/
│   └── refs/
├── .gitignore
├── .metadata
├── AGENTS.md
├── README.md
├── analysis_options.yaml
├── laporkerja-summary.md
├── mise.toml
├── pubspec.lock
└── pubspec.yaml
```

## Code Style

- **Imports**: Kelompokkan berdasarkan tipe (dart, flutter, third-party, local) dengan baris kosong di antara
- **Naming**: camelCase untuk variabel/fungsi, PascalCase untuk class, snake_case untuk file
- **Types**: Gunakan tipe eksplisit untuk public APIs, `const` untuk konstanta compile-time
- **Widgets**: Gunakan `const` constructors jika memungkinkan, prefer `StatelessWidget` over `StatefulWidget`
- **State management**: Gunakan Riverpod providers, hindari setState di widget kompleks
- **Error handling**: Gunakan `Result<T>` untuk operasi async di repositories, try-catch untuk operasi lain, throw custom exceptions
- **Annotations**: Gunakan `@freezed` untuk data classes, `@JsonSerializable` untuk JSON models, `@DriftTable` untuk database entities
- **Formatting**: Ikuti output dartfmt, indentasi 2-spasi, batas 80 karakter per baris
- **Documentation**: Gunakan `///` untuk public APIs, hindari komentar inline kecuali logika kompleks

## Use Case Structure Guidelines

- **Folder Structure**: Kelompokkan use cases berdasarkan entitas (misalnya `client/`, `project/`), kemudian berdasarkan aksi (misalnya `add_client/`, `update_client/`, `delete_client/`).
- **Pemisahan File**: Pisahkan Params dan UseCase ke file berbeda (misalnya `add_client_params.dart` dan `add_client_usecase.dart`).
- **Implementasi Interface**: Use case yang mengembalikan `Future<Result<...>>` harus mengimplementasikan `UseCase<R, P>` dengan class Params yang sesuai.
- **Get Use Cases**: Use case untuk pengambilan data (misalnya `GetClientsUseCase`) tidak perlu Params dan bisa dalam satu file tanpa subfolder.
- **Contoh Struktur**:
  ```
  lib/domain/usecases/client/
  ├── add_client/
  │   ├── add_client_params.dart
  │   └── add_client_usecase.dart
  ├── update_client/
  │   ├── update_client_params.dart
  │   └── update_client_usecase.dart
  ├── delete_client/
  │   ├── delete_client_params.dart
  │   └── delete_client_usecase.dart
  └── get_clients_usecase.dart
  ```

## Contributing

1. Fork repository
2. Buat branch fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## Lisensi

TBD